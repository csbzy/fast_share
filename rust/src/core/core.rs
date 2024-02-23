use crate::api::command::{event, RequestToReceive};
use crate::api::command::{
    share_file_client::ShareFileClient, share_file_server::*, upload_file_request, FileMetaData,
    Resp, SendFile, UploadFileRequest,
};
use crate::api::command::{upload_file_request::UploadFileEnum, Event};
use crate::frb_generated::StreamSink;
use flutter_rust_bridge::frb;
use lazy_static::lazy_static;
use log::error;
use md5;
use std::collections::HashMap;
use std::pin::Pin;
use std::sync::Arc;
use tokio::io::AsyncReadExt;
use tokio::sync::mpsc;
use tokio::{
    fs,
    io::{self, AsyncWriteExt},
    sync::mpsc::{Receiver, Sender},
    sync::Mutex,
};
use tokio_stream::{wrappers::ReceiverStream, Stream, StreamExt};
use tonic::{transport::Server, Request, Response, Status, Streaming};
lazy_static! {
    pub static ref JUSTSHARE_CORE: MutexJustShareCore = MutexJustShareCore::new();
}

#[frb(ignore)]
pub struct MutexJustShareCore {
    pub core: Arc<Mutex<JustShareCore>>,
}

impl MutexJustShareCore {
    pub fn new() -> MutexJustShareCore {
        MutexJustShareCore {
            core: Arc::new(Mutex::new(JustShareCore::new(JustShareCoreConfig {
                port: 8965,
            }))), //
        }
    }

    pub async fn send_file(&self, message: SendFile) {
        error!("enter send file");
        let core_clone = self.core.clone(); // Create a clone of the Arc
        flutter_rust_bridge::spawn(async move {
            error!("enter send file spawn");

            let mut core_lock = core_clone.lock().await; // Use the cloned Arc inside the async block         // let mut core = core_lock.await;
            let _ = core_lock.send_file(message).await;
        })
        .await
        .unwrap();
    }

    pub async fn start_receive_file(&self) {
        error!("start handle receive file");
        let core_clone = self.core.clone();
        let core_lock = core_clone.lock().await;
        let port = core_lock.config.port;
        start_receive_file(port).await;
        error!("unlock core");
    }

    pub async fn comfirm_receive_file(&self, name: String) {
        let core_clone = Arc::clone(&self.core);
        let core = core_clone.lock();
        let db = &mut core.await.comfirm_receive_db;
        let mut db = db.lock().await;

        if let Some(comfirm_tx) = db.remove(&name) {
            // The following line should work without cloning comfirm_tx,
            // because db.remove() gives us ownership of the value.
            let _ = comfirm_tx.send("accept".to_string()); // Ignore the result with let _
        }
        error!("comfirm_receive_file nlock core");
    }

    pub async fn do_receive_file(
        &self,
        stream: Streaming<UploadFileRequest>,
        tx: Sender<Result<Resp, Status>>,
        from: String,
    ) {
        error!("do_receive_file upload file");
        let core_clone = Arc::clone(&self.core); // Create a clone of the Arc
        error!("do_receive_file upload file wait lock");

        let core_lock = core_clone.lock().await;
        error!("do_receive_file upload file get lock");

        core_lock.do_receive_file(stream, tx, from).await
    }

    pub async fn async_event_to_frontend(&self, sink: StreamSink<Event>) {
        error!("send async even to frontend");
        let core_clone: Arc<Mutex<JustShareCore>> = Arc::clone(&self.core);
        let core_lock = core_clone.lock().await; // Use the cloned Arc inside the async block
        let c = core_lock.frontend_channel_receiver.clone(); // Create a clone of the Arc
        flutter_rust_bridge::spawn(async move {
            let rc = &mut c.lock().await;
            loop {
                while let Some(event) = rc.recv().await {
                    let result = sink.add(event.clone());
                    error!("send event: {:?} to frontend resut:{:?}", event, result);
                }
            }
        });
        error!("async_event_to_frontend unlock core")
    }
}

#[frb(ignore)]
async fn start_receive_file(port: u16) {
    flutter_rust_bridge::spawn(async move {
        error!("ENTER SPAWN start handle receive file");
        let addr = format!("127.0.0.1:{}", port.to_string()).parse().unwrap();
        let sf = MyShareFileServer::default();
        println!("fileListenServer listening on {}", addr);
        Server::builder()
            .add_service(ShareFileServer::new(sf))
            .serve(addr)
            .await
            .unwrap();
        error!("LEAVE SPAWN start handle receive file");
    });
}

type EventChannelSender = Arc<Mutex<Sender<Event>>>;
type EventChannelReceiver = Arc<Mutex<Receiver<Event>>>;
type Db = Arc<Mutex<HashMap<String, Arc<Sender<String>>>>>;

#[frb(ignore)]
struct JustShareCore {
    pub config: JustShareCoreConfig,
    pub listener: Arc<tokio::sync::Mutex<Option<tokio::net::TcpListener>>>,
    pub frontend_channel_sender: EventChannelSender,
    pub frontend_channel_receiver: EventChannelReceiver,
    pub comfirm_receive_db: Db,
}

impl JustShareCore {
    pub fn new(config: JustShareCoreConfig) -> JustShareCore {
        let (tx, rx) = mpsc::channel::<Event>(32);

        let c = JustShareCore {
            config: config,
            frontend_channel_sender: Arc::new(Mutex::new(tx)),
            frontend_channel_receiver: Arc::new(Mutex::new(rx)),
            listener: Arc::new(Mutex::new(None)),
            comfirm_receive_db: Arc::new(Mutex::new(HashMap::new())),
        };
        c
    }

    async fn do_send_event_to_frontend(channel: EventChannelSender, envent: Event) {
        error!("lock to send envent: {:?}", envent);
        let channel = channel.lock().await;
        error!("get channel lock");
        channel.send(envent).await.unwrap();
        error!("finished send envent:");
    }

    async fn send_file(&mut self, message: SendFile) -> io::Result<()> {
        error!("enter core send: {:?}", message);
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
        error!("start send request: {:?}", request);

        error!("send request {:?}", tx.send(request).await);
        error!("finish send request: file meta data",);

        let response = client.unwrap().upload_file(request_stream).await.unwrap();
        let mut resp_stream = response.into_inner();
        flutter_rust_bridge::spawn(async move {
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

    pub async fn do_receive_file(
        &self,
        mut stream: Streaming<UploadFileRequest>,
        tx: Sender<Result<Resp, Status>>,
        from: String,
    ) -> Result<(), Box<dyn std::error::Error>>{
        error!("just share core do to receive upload file");

        let frontend_channel = self.frontend_channel_sender.clone();
        let db = self.comfirm_receive_db.clone();
        flutter_rust_bridge::spawn(async move {
            error!("just share core do to receive upload file spawn");

            let mut file_path = String::new();
            let mut file = None;

            while let Some(upload) = stream.message().await.unwrap() {
                match upload.upload_file_enum {
                    Some(upload_file_request::UploadFileEnum::MetaData(metadata)) => {
                        error!("receive upload file meta data {:?}", metadata);
                        // notify frontend to accept receive file
                        let (comfirm_tx, mut comfirm_rx) = mpsc::channel::<String>(10);
                        error!("try to lock db");
                        db.lock()
                            .await
                            .insert(metadata.file_name.clone(), Arc::new(comfirm_tx));
                        error!("unlock db");

                        error!("try send event to frontend");
                        JustShareCore::do_send_event_to_frontend(
                            frontend_channel.clone(),
                            Event {
                                event_enum: Some(event::EventEnum::RequestToReceive(
                                    RequestToReceive {
                                        file_name: metadata.file_name.clone(),
                                        from: from.clone(),
                                    },
                                )),
                            },
                        )
                        .await;

                        error!("wait for comfirm response");
                        // wait for response
                        let s = comfirm_rx.recv().await;
                        error!("receive confirm response{:?}", s);

                        // Process file metadata
                        // TODO: change file path prefix
                        file_path =
                            format!("/home/bobo/workspace/just_share/{}", metadata.file_name);
                        error!("start to create file: {:?}", file_path);
                        file = Some(tokio::fs::File::create(&file_path).await.map_err(|e| {
                            error!("create file error: {:?}", e);
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
        let from = req.remote_addr().unwrap();

        let stream: Streaming<UploadFileRequest> = req.into_inner();
        let (tx, rx) = mpsc::channel(10);
        error!("start to receive upload file");
        //TODO handle error
        let res =JUSTSHARE_CORE
            .do_receive_file(stream, tx, from.to_string())
            .await;

        // echo just write the same data that was received
        let out_stream = ReceiverStream::new(rx);

        Ok(Response::new(Box::pin(out_stream) as Self::UploadFileStream))
    }
}

#[derive(Clone)]
pub struct JustShareCoreConfig {
    pub port: u16,
}
