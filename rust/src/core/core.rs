use crate::api::command::*;
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
use prost::Message;
use std::borrow::Borrow;
use std::collections::HashMap;
use std::error::{self, Error};
use std::net::{IpAddr, Ipv4Addr};
use std::pin::Pin;
use std::sync::Arc;
use tokio::io::AsyncReadExt;
use tokio::net::UdpSocket;
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

    pub async fn discovery(&self) {
        let core_clone = self.core.clone();
        // let core_lock = core_clone.lock().await;

        let _ = JustShareCore::discovery(core_clone).await;
    }

    pub async fn refresh_discovery(&self) {
        let core_lock = self.core.lock().await;
        let tx = core_lock.discovery_channel_sender.lock().await;
        tx.send(()).await.unwrap();
    }

    pub async fn start_receive_file(&self) {
        error!("start handle receive file");
        let core_clone = self.core.clone();
        let core_lock = core_clone.lock().await;
        let port = core_lock.config.port;
        flutter_rust_bridge::spawn(async move {
            error!("ENTER SPAWN start handle receive file");
            let addr = format!("0.0.0.0:{}", port.to_string()).parse().unwrap();
            let sf = MyShareFileServer::default();
            println!("fileListenServer listening on {}", addr);
            Server::builder()
                .add_service(ShareFileServer::new(sf))
                .serve(addr)
                .await
                .unwrap();
            error!("LEAVE SPAWN start handle receive file");
        });

        error!("unlock core");
    }

    pub async fn comfirm_receive_file(&self, name: String) {
        let core_clone = Arc::clone(&self.core);
        error!("start to get core lock");
        let core = core_clone.lock().await;
        error!("comfirm_receive_file lock core");
        let db = &core.comfirm_receive_db;
        error!("start to get db lock");
        let mut db = db.lock().await;
        error!("db lock get");
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
        tx: Sender<Result<UploadFileResp, Status>>,
        from: String,
    ) {
        error!("do_receive_file upload file");
        let core_clone = Arc::clone(&self.core); // Create a clone of the Arc
        error!("do_receive_file upload file wait lock");

        let core_lock = core_clone.lock().await;
        error!("do_receive_file upload file get lock");

        core_lock.do_receive_file(stream, tx, from).await;
    }

    pub async fn async_event_to_frontend(&self, sink: StreamSink<Event>) {
        let mut core = self.core.lock().await;
        core.event_to_frontend_channel = Some(sink);
    }
}

// #[frb(ignore)]
// async fn start_receive_file(port: u16) {}

// type EventChannelSender = Arc<Mutex<Sender<Event>>>;
// type EventChannelReceiver = Arc<Mutex<Receiver<Event>>>;
type EventToFrontendChannel = Option<StreamSink<Event>>;
type Db = Arc<Mutex<HashMap<String, Arc<Sender<String>>>>>;

#[frb(ignore)]
struct JustShareCore {
    pub config: JustShareCoreConfig,
    pub listener: Arc<tokio::sync::Mutex<Option<tokio::net::TcpListener>>>,
    // pub frontend_channel_sender: EventChannelSender,
    // pub frontend_channel_receiver: EventChannelReceiver,
    pub event_to_frontend_channel: EventToFrontendChannel,
    pub discovery_channel_sender: Arc<Mutex<Sender<()>>>,
    pub discovery_channel_receiver: Arc<Mutex<Receiver<()>>>,
    pub comfirm_receive_db: Db,
    pub discovery_db: Arc<Mutex<HashMap<String, String>>>,
}

impl JustShareCore {
    pub fn new(config: JustShareCoreConfig) -> JustShareCore {
        let (tx, rx) = mpsc::channel::<Event>(32);
        let (dtx, drx) = mpsc::channel::<()>(1);

        let c = JustShareCore {
            config: config,
            // frontend_channel_sender: Arc::new(Mutex::new(tx)),
            // frontend_channel_receiver: Arc::new(Mutex::new(rx)),
            event_to_frontend_channel: None,
            listener: Arc::new(Mutex::new(None)),
            comfirm_receive_db: Arc::new(Mutex::new(HashMap::new())),
            discovery_channel_sender: Arc::new(Mutex::new(dtx)),
            discovery_channel_receiver: Arc::new(Mutex::new(drx)),
            discovery_db: Arc::new(Mutex::new(HashMap::new())),
            // discovery_channel_receiver: drx,
        };
        c
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
                let resp = received.unwrap();
                error!("received message: `{:?}`", resp);

                match resp {
                    UploadFileResp {
                        upload_file_resp_enum:
                            Some(upload_file_resp::UploadFileRespEnum::AcceptFile(a)),
                    } => {
                        error!("get accept file resp: {:?},start to send file byte", a);

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

                        tx.send(UploadFileRequest {
                            upload_file_enum: Some(UploadFileEnum::Finish(Finish {})),
                        })
                        .await
                        .unwrap();
                    }

                    _r => {
                        error!("UploadFileResponse: {:?}", _r);
                    }
                }
            }
        });

        Ok(())
    }

    pub async fn do_receive_file(
        &self,
        mut stream: Streaming<UploadFileRequest>,
        tx: Sender<Result<UploadFileResp, Status>>,
        from: String,
    ) {
        error!("just share core do to receive upload file");

        let db = self.comfirm_receive_db.clone();
        let event_to_frontend = self.event_to_frontend_channel.as_ref().unwrap().clone();

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
                        let _ = event_to_frontend.add(Event {
                            event_enum: Some(event::EventEnum::RequestToReceive(
                                RequestToReceive {
                                    file_name: metadata.file_name.clone(),
                                    from: from.clone(),
                                },
                            )),
                        });

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
                            .send(Ok(UploadFileResp {
                                upload_file_resp_enum: Some(
                                    upload_file_resp::UploadFileRespEnum::AcceptFile(AcceptFile {}),
                                ),
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
                    Some(upload_file_request::UploadFileEnum::Finish(_)) => {
                        error!("receive upload file finish");
                        if let Some(file) = file.as_mut() {
                            file.flush().await.map_err(|e| {
                                Status::internal(format!("Failed to flush file: {}", e))
                            })?;
                            file.sync_all().await.map_err(|e| {
                                Status::internal(format!("Failed to sync file: {}", e))
                            })?;
                        }
                        return Ok(());
                    }

                    None => {
                        return Err(Status::invalid_argument("No file data provided"));
                    }
                }
            }
            error!("stream end");
            Ok(())
        });
        // .await
        // .unwrap()?)
    }

    pub async fn discovery(core: Arc<Mutex<JustShareCore>>) {
        let core_clone = core.lock().await;
        let event_to_frontend = core_clone.event_to_frontend_channel.clone().unwrap();

        let socket = UdpSocket::bind("0.0.0.0:9999").await.unwrap();

        let local_ip = {
            let socket1 = UdpSocket::bind("0.0.0.0:0")
                .await
                .map_err(|e| format!("Failed to bind socket: {}", e));
            let socket1 = socket1.unwrap();

            let _ = socket1
                .connect("8.8.8.8:80")
                .await
                .map_err(|e| format!("Failed to connect to remote host: {}", e));
            socket1
                .local_addr()
                .map(|addr| match addr.ip() {
                    IpAddr::V4(ipv4) => Ok(ipv4),
                    IpAddr::V6(_) => Err("IPv6 is not supported".to_string()),
                })
                .unwrap_or_else(|e| Err(format!("Failed to get local IP address: {}", e)))
        };

        socket.set_broadcast(true).unwrap();
        let rx = core_clone.discovery_channel_receiver.clone();
        let tx = core_clone.discovery_channel_sender.clone();
        let sender = tx.lock().await;
        let _ = sender.send(()).await;
        let local_ip = local_ip.unwrap();
        error!("server local ip {:}", socket.local_addr().unwrap().ip());

        let db = core_clone.discovery_db.clone();
        flutter_rust_bridge::spawn(async move {
            let mut buf = [0; 1024];
            loop {
                let mut rx = rx.lock().await;
                tokio::select! {
                    Ok((number_of_bytes,src_addr))=socket.recv_from(&mut buf)=>{
                        error!("Received {} bytes from {:?}", number_of_bytes, src_addr);
                        let src_ip = src_addr.ip();
                        error!("srcip: {:?} local_ip: {:?}", src_ip,local_ip);
                        if src_ip == local_ip{
                            error!("rece discovery ip from same ip");
                            continue
                        }

                        let message = String::from_utf8_lossy(&buf[..number_of_bytes]);
                        error!("Message: {}", message);
                        let message = prost::Message::decode(&buf[..number_of_bytes]).unwrap();
                        let src_ip = src_addr.ip();
                        match message {
                            DiscoveryReq {  } => {
                                // error!("discovery ip: {:?}", addr);
                                let resp =DiscoveryResp{
                                                addr: local_addr.to_string(),
                                                hostname:
                                            },
                                let mut buf = vec![];
                                resp.encode(&mut buf).unwrap();
                                let res = socket.send_to(&buf, src_addr).await;
                                error!("send hello res: {:?}", res);
                            }

                            DiscoveryResp { hostname: "" } => {
                                error!("discovery ip: {:?}", addr);
                            }
                        }

                        error!("wait for db lock");
                        let mut db = db.lock().await;
                        error!("wait for db lock ");

                        if let Some(_ip) = db.get(&src_ip.to_string()) {
                            error!("had receive from ip: {}", _ip);
                            continue
                        }

                        db.insert(src_ip.to_string(), src_ip.to_string());

                        // Send the message to the frontend
                        let event = Event {
                        event_enum: Some(event::EventEnum::DiscoveryIp(
                        crate::api::command::DiscoveryIp {
                            addr: src_addr.to_string(),
                            },
                         )),
                        };
                        let _ = event_to_frontend.add(event);


                        // You can now handle the incoming message and potentially
                        // identify the IP address of the sender or take other actions.
                    }

                    Some(()) =rx.recv() => {
                        error!("discovery end");
                        let mut db = db.lock().await;
                        db.clear();
                                    // Send a discovery message
                        let discovery_message = DiscoveryReq{};
                        let mut buf = vec![];
                        discovery_message.encode(&mut buf).unwrap();
                        let result = socket
                            .send_to(&buf, "255.255.255.255:9999")
                            .await;
                        error!("discovery result: {:?}", result);
                    }

                }
            }
        });
    }
}

#[derive(Default)]
pub struct MyShareFileServer {}
type ResponseStream = Pin<Box<dyn Stream<Item = Result<UploadFileResp, Status>> + Send>>;

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
        let res = JUSTSHARE_CORE
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
