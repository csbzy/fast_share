use crate::api::command::upload_file_request::UploadFileEnum;
use crate::api::command::{
    share_file_client::ShareFileClient, share_file_server::*, upload_file_request, FileMetaData,
    Resp, SendFile, UploadFileRequest,
};
use lazy_static::lazy_static;
use log::error;
use md5;
use std::pin::Pin;
use std::sync::Arc;
use tokio::io::AsyncReadExt;
use tokio::sync::mpsc;
use tokio::{
    fs,
    io::{self, AsyncWriteExt},
    sync::{
        mpsc::{Receiver, Sender},
        Mutex,
    },
};
use tokio_stream::{wrappers::ReceiverStream, Stream, StreamExt};
use tonic::{transport::Server, Request, Response, Status, Streaming};
lazy_static! {
    pub static ref JUSTSHARE_CORE: MutexJustShareCore = MutexJustShareCore::new();
}

pub struct MutexJustShareCore {
    pub core: std::sync::Arc<Mutex<Option<JustShareCore>>>,
}

impl MutexJustShareCore {
    pub fn new() -> MutexJustShareCore {
        MutexJustShareCore {
            core: Arc::new(Mutex::new(None)),
        }
    }

    pub async fn send_file(&self, message: SendFile) {
        let core_clone = Arc::clone(&self.core); // Create a clone of the Arc
        flutter_rust_bridge::spawn(async move {
            let mut core_lock = core_clone.lock().await; // Use the cloned Arc inside the async block
            let core: &mut JustShareCore = core_lock.as_mut().unwrap();
            let _ = core.send(message).await;
        })
        .await
        .unwrap();
    }

    pub async fn handle_receive_file(core: std::sync::Arc<Mutex<Option<JustShareCore>>>) {
        error!("start handle receive file");
        let core_clone = core.clone();
        flutter_rust_bridge::spawn(async move {
            error!("ENTER SPAWN start handle receive file");

            core_clone.lock().await.as_mut().unwrap().receive().await;
        })
        .await
        .unwrap();
    }
}
pub struct JustShareCore {
    pub config: JustShareCoreConfig,
    pub sender: Arc<Mutex<Sender<String>>>,
    pub receiver: Arc<Mutex<Receiver<String>>>,
    pub listener: Arc<Mutex<Option<tokio::net::TcpListener>>>,
}

impl JustShareCore {
    pub fn new(config: JustShareCoreConfig) -> JustShareCore {
        let (sender, receiver) = mpsc::channel(32);
        let sender = Arc::new(Mutex::new(sender));
        let receiver = Arc::new(Mutex::new(receiver));
        let c = JustShareCore {
            config,
            sender,
            receiver,
            listener: Arc::new(Mutex::new(None)),
        };
        // c.start();
        c
    }

    async fn send(&mut self, message: SendFile) -> io::Result<()> {
        error!("send: {:?}", message);

        let client = ShareFileClient::connect(format!("http://{:}", message.addr)).await;
        let file_path = message.path.clone();

        let file = tokio::fs::File::open(file_path.clone()).await?;
        let file_metadata = file.metadata().await?;
        let file_size = file_metadata.len();

        drop(file);
        // Compute MD5 checksum of the file.
        let file_byte: Vec<u8> = fs::read(message.path).await?;

        let md5_checksum = md5::compute(file_byte.clone());
        let file_name = file_path.split("/").last().unwrap_or_default();

        let (tx, rx) = mpsc::channel(128);
        let request_stream = ReceiverStream::new(rx);

        let request = UploadFileRequest {
            upload_file_enum: Some(UploadFileEnum::MetaData(FileMetaData {
                file_name: file_name.to_string(),
                file_size: file_size as i32,
                md5: format!("{:x}", md5_checksum),
            })),
        };

        let response = client.unwrap().upload_file(request_stream).await.unwrap();
        let mut resp_stream = response.into_inner();
        flutter_rust_bridge::spawn(async move {
            error!("start send request: {:?}", request);

            tx.send(request).await.unwrap();
            error!("finish send request: file meta data",);
            while let Some(received) = resp_stream.next().await {
                let received = received.unwrap();
                error!("\treceived message: `{}`", received.msg);

                match received.code {
                    1 => {
                        error!("UploadFileRequest: {:?},start to send file byte", received);

                        let mut file = tokio::fs::File::open(file_path.clone()).await.unwrap();
                        let mut buffer = [0; 4096]; // 4KB buffer
                        loop {
                            let bytes_read = file.read(&mut buffer).await.unwrap();
                            if bytes_read == 0 {
                                break;
                            }

                            tx.send(UploadFileRequest {
                                upload_file_enum: Some(UploadFileEnum::Content(buffer.to_vec())),
                            })
                            .await
                            .unwrap();
                        }
                    }

                    _r => {
                        error!("UploadFileResponse: {:?}", received);
                    }
                }
            }
        });

        Ok(())
    }

    async fn receive(&mut self) {
        error!("start to listen lis: {:?}", self.listener);
        let addr = format!("127.0.0.1:{}", &self.config.port.to_string())
            .parse()
            .unwrap();
        let sf = MyShareFileServer::default();
        println!("HealthServer + GreeterServer listening on {}", addr);

        Server::builder()
            .add_service(ShareFileServer::new(sf))
            .serve(addr)
            .await
            .unwrap();
    }
}

#[derive(Default)]
pub struct MyShareFileServer {}
type ResponseStream = Pin<Box<dyn Stream<Item = Result<Resp, Status>> + Send>>;

#[tonic::async_trait]
impl ShareFile for MyShareFileServer {
    type UploadFileStream = ResponseStream;
    async fn upload_file(
        &self,
        req: Request<tonic::Streaming<UploadFileRequest>>,
    ) -> std::result::Result<Response<Self::UploadFileStream>, Status> {
        let mut stream: Streaming<UploadFileRequest> = req.into_inner();
        let mut file_path = String::new();
        let mut file = None;
        let (tx, rx) = mpsc::channel(128);
        error!("start to receive upload file");
        flutter_rust_bridge::spawn(async move {
            while let Some(upload) = stream.message().await.unwrap() {
                match upload.upload_file_enum {
                    Some(upload_file_request::UploadFileEnum::MetaData(metadata)) => {
                        error!("receive upload file meta data {:?}", metadata);

                        // Process file metadata
                        file_path =
                            format!("/home/bobo/workspace/just_share/{}", metadata.file_name);
                        error!("start to create file: {:?}", file_path);
                        file = Some(tokio::fs::File::create(&file_path).await.map_err(|e| {
                            Status::internal(format!("Failed to create file: {}", e))
                        })?);
                        let r = tx
                            .send(Ok(Resp {
                                code: 1,
                                msg: "can send file byte".into(),
                            }))
                            .await
                            .unwrap();
                        error!("tell client to send file byte response: {:?}", r);
                    }
                    Some(upload_file_request::UploadFileEnum::Content(chunk)) => {
                        // Process file chunk
                        error!("receive upload file chunk");

                        if let Some(file) = file.as_mut() {
                            file.write_all(&chunk).await.map_err(|e| {
                                Status::internal(format!("Failed to write to file: {}", e))
                            })?;
                        } else {
                            return Err(Status::failed_precondition("No file metadata provided"));
                        }
                    }
                    None => {
                        return Err(Status::invalid_argument("No file data provided"));
                    }
                }
            }
            error!("stream end");
            Ok(())
        });

        // echo just write the same data that was received
        let out_stream = ReceiverStream::new(rx);

        Ok(Response::new(Box::pin(out_stream) as Self::UploadFileStream))
    }
}

#[derive(Clone)]
pub struct JustShareCoreConfig {
    pub port: u16,
}
