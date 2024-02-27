use crate::api::command::*;
use crate::api::command::{
    discovery_event::*, share_file_client::ShareFileClient, share_file_server::*,
    upload_file_request, FileMetaData, SendFile, UploadFileRequest,
};
use crate::api::command::{upload_file_request::UploadFileEnum, Event};
use crate::frb_generated::StreamSink;
use flutter_rust_bridge::frb;
use lazy_static::lazy_static;
use log::error;
use md5;
use prost::Message;
use std::collections::HashMap;
use std::net::{IpAddr, Ipv4Addr, SocketAddrV4};
use std::path::PathBuf;
use std::pin::Pin;
use std::sync::Arc;
use std::time::Duration;
use tokio::io::AsyncReadExt;
use tokio::net::UdpSocket;
use tokio::sync::mpsc;
use tokio::time::sleep;
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
        let hostname = match std::env::var("HOSTNAME") {
            Ok(val) => val,
            Err(_) => "localhost".to_string(), // Fallback to "localhost" if HOSTNAME environment variable is not set
        };
        MutexJustShareCore {
            core: Arc::new(Mutex::new(JustShareCore::new(JustShareCoreConfig {
                port: 8965,
                hostname: hostname,
                save_directory: "".to_string(),
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
        error!("start refresh discovery wait lock");
        let core_lock = self.core.lock().await;
        error!("start refresh discovery wait channel lock");

        let tx = core_lock.discovery_channel_sender.lock().await;
        error!("start refresh discovery send");

        tx.send(()).await.unwrap();
    }

    pub async fn init_core(&self, hostname: String, directory: String) {
        let mut core_lock = self.core.lock().await;
        core_lock.config.hostname = hostname;
        core_lock.config.save_directory = directory;
    }

    pub async fn start_receive_file(&self) {
        error!("start handle receive file");
        let core_clone = self.core.clone();
        let core_lock = core_clone.lock().await;
        let port = core_lock.config.port.clone();
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

    pub async fn comfirm_receive_file(&self, accept: bool, file_name: String) {
        let core_clone = Arc::clone(&self.core);
        error!("start to get core lock for {:?}", file_name);
        let core = core_clone.lock().await;
        error!("comfirm_receive_file lock core");
        let db = &core.comfirm_receive_db;
        error!("start to get db lock");
        let mut db = db.lock().await;
        error!("db lock get");
        match db.remove(&file_name) {
            Some(comfirm_tx) => {
                let resp = comfirm_tx.send(accept).await; // Ignore the result with let _
                error!("comfirm_receive_file send resp {:?}", resp);
            }

            None => {
                error!("comfirm_receive_file not found");
            }
        }
        error!("comfirm_receive_file nlock core");
    }

    pub async fn do_receive_file(
        &self,
        stream: Streaming<UploadFileRequest>,
        tx: Sender<Result<UploadFileResp, Status>>,
        from: String,
    ) {
        let mut save_directory = "".to_string();
        {
            error!("do_receive_file upload file");
            let core_clone = Arc::clone(&self.core); // Create a clone of the Arc
            error!("do_receive_file upload file wait lock");

            let core_lock = core_clone.lock().await;
            error!("do_receive_file upload file get lock");
            save_directory = core_lock.config.save_directory.clone();
        }
        JustShareCore::do_receive_file(save_directory, stream, tx, from).await;
    }

    pub async fn async_event_to_frontend(&self, sink: StreamSink<Event>) {
        let mut core = self.core.lock().await;
        core.event_to_frontend_channel = Some(sink);
    }
}

type EventToFrontendChannel = Option<StreamSink<Event>>;
type Db = Arc<Mutex<HashMap<String, Arc<Sender<bool>>>>>;

#[frb(ignore)]
struct JustShareCore {
    pub config: JustShareCoreConfig,
    pub listener: Arc<tokio::sync::Mutex<Option<tokio::net::TcpListener>>>,
    pub event_to_frontend_channel: EventToFrontendChannel,
    pub discovery_channel_sender: Arc<Mutex<Sender<()>>>,
    pub discovery_channel_receiver: Arc<Mutex<Receiver<()>>>,
    pub comfirm_receive_db: Db,
    pub discovery_db: Arc<Mutex<HashMap<String, String>>>,
}

impl JustShareCore {
    pub fn new(config: JustShareCoreConfig) -> JustShareCore {
        let (dtx, drx) = mpsc::channel::<()>(10);

        let c = JustShareCore {
            config: config,
            event_to_frontend_channel: None,
            listener: Arc::new(Mutex::new(None)),
            comfirm_receive_db: Arc::new(Mutex::new(HashMap::new())),
            discovery_channel_sender: Arc::new(Mutex::new(dtx)),
            discovery_channel_receiver: Arc::new(Mutex::new(drx)),
            discovery_db: Arc::new(Mutex::new(HashMap::new())),
        };
        c
    }

    async fn send_file(&mut self, message: SendFile) -> io::Result<()> {
        error!("enter core send: {:?}", message);
        let client = ShareFileClient::connect(format!("http://{:}", message.addr)).await;
        let file_paths = message.path.clone();

        if file_paths.is_empty() {
            return Ok(());
        }

        let first_file_name = file_paths[0].split("/").last().unwrap_or_default();

        let req = RequestAcceptFileReq {
            first_file_name: first_file_name.to_string(),
            file_num: file_paths.len() as i32,
        };

        let resp = client
            .unwrap()
            .request_accept_file(req)
            .await
            .unwrap()
            .into_inner();
        if !resp.accept {
            return Ok(());
        }
        Ok(for file_path in file_paths.clone() {
            let addr = message.addr.clone();
            flutter_rust_bridge::spawn(async move {
                let client = ShareFileClient::connect(format!("http://{:}", addr)).await;

                let path = file_path.clone();
                let file = tokio::fs::File::open(path.clone()).await.unwrap();
                let file_metadata = file.metadata().await.unwrap();
                let file_size = file_metadata.len();
                drop(file);
                // Compute MD5 checksum of the file.
                let file_byte: Vec<u8> = fs::read(path).await.unwrap();
                let md5_checksum = md5::compute(file_byte.clone());

                let file_path = file_path.clone();
                let file_name = file_path.split("/").last().unwrap_or_default();

                let request = UploadFileRequest {
                    upload_file_enum: Some(UploadFileEnum::MetaData(FileMetaData {
                        file_name: file_name.to_string(),
                        file_size: file_size as i32,
                        md5: format!("{:x}", md5_checksum),
                    })),
                };

                error!("start send request: {:?}", request);
                let (tx, rx) = mpsc::channel(5);
                let request_stream = ReceiverStream::new(rx);
                let response = client.unwrap().upload_file(request_stream).await.unwrap();
                let mut resp_stream = response.into_inner();
                let res = tx.send(request).await.unwrap();
                error!(
                    "send file meta data res: {:?}, file bytes:{:?}",
                    res,
                    file_byte.len()
                );
                error!("finish send request: file meta data",);

                let max_packet_size = 1024; // 每包最大1MB
                for chunk in file_byte.chunks(max_packet_size) {
                    let res = tx
                        .send(UploadFileRequest {
                            upload_file_enum: Some(UploadFileEnum::Content(chunk.to_vec())),
                        })
                        .await
                        .unwrap();

                    error!("send file content res: {:?}", res);
                    // while let Some(response) = resp_stream.message().await.unwrap() {
                    //     // Handle the response here
                    //     println!("Received response: {:?}", response);
                    // }
                }

                let res = tx
                    .send(UploadFileRequest {
                        upload_file_enum: Some(UploadFileEnum::Finish(Finish {})),
                    })
                    .await
                    .unwrap();

                error!("send file finish res: {:?}", res);
            });
        })
    }

    //     let request = UploadFileRequest {
    //         upload_file_enum: Some(UploadFileEnum::RequestAccept(RequestAccept {
    //             first_file_name: first_file_name.to_string(),
    //             file_num: file_paths.len() as i32,
    //         })),
    //     };
    //     error!("start send request: {:?}", request);
    //     let (tx, rx) = mpsc::channel(5);

    //     error!("send request {:?}", tx.send(request).await);
    //     error!("finish send request: file meta data",);
    //     let request_stream = ReceiverStream::new(rx);

    //     let response = client.unwrap().upload_file(request_stream).await.unwrap();
    //     let mut resp_stream = response.into_inner();
    //     flutter_rust_bridge::spawn(async move {
    //         while let Some(received) = resp_stream.next().await {
    //             let resp = received.unwrap();
    //             error!("received message: `{:?}`", resp);

    //             match resp {
    //                 UploadFileResp {
    //                     upload_file_resp_enum:
    //                         Some(upload_file_resp::UploadFileRespEnum::AcceptFile(a)),
    //                 } => {
    //                     error!("get accept file resp: {:?},start to send file byte", a);

    //                 }

    //                 _r => {
    //                     error!("UploadFileResponse: {:?}", _r);
    //                 }
    //             }
    //         }
    //     });

    //     Ok(())
    // }
    pub async fn do_requset_accept_file_to_frontend(
        comfirm_receive_db: Arc<Mutex<HashMap<String, Arc<mpsc::Sender<bool>>>>>,
        event_to_frontend_channel: StreamSink<Event>,
        request: RequestAcceptFileReq,
        from: String,
    ) -> Result<Response<RequestAcceptFileResp>, Status> {
        let db = comfirm_receive_db.clone();
        let (comfirm_tx, mut comfirm_rx) = mpsc::channel::<bool>(1);
        error!("try to lock db");
        db.lock()
            .await
            .insert(request.first_file_name.clone(), Arc::new(comfirm_tx));
        error!("unlock db");

        let event_to_frontend = event_to_frontend_channel.clone();
        error!("try send event to frontend");
        let _ = event_to_frontend.add(Event {
            event_enum: Some(event::EventEnum::RequestToReceive(RequestToReceive {
                file_name: request.first_file_name.clone(),
                from: from.clone(),
                file_num: request.file_num,
            })),
        });

        error!("wait for comfirm response");
        // wait for response
        let s = comfirm_rx.recv().await;

        error!("get comfirm response: {:?}", s);
        let accept = s.unwrap();

        Ok(Response::new(RequestAcceptFileResp { accept: accept }))
    }

    pub async fn do_receive_file(
        save_directory: String,
        mut stream: Streaming<UploadFileRequest>,
        tx: Sender<Result<UploadFileResp, Status>>,
        from: String,
    ) {
        error!("just share core do to receive upload file from {:}", from);
        let save_path: String = save_directory;
        flutter_rust_bridge::spawn(async move {
            error!("just share core do to receive upload file spawn");
            let mut file = None;

            while let Some(upload) = stream.message().await.unwrap() {
                match upload.upload_file_enum {
                    Some(upload_file_request::UploadFileEnum::MetaData(metadata)) => {
                        error!("receive upload file meta data {:?}", metadata);
                        let filename = metadata.file_name.clone();
                        error!("try to lock db");
                        let mut file_path = PathBuf::from(save_path.clone());
                        file_path.push(filename);
                        error!("start to create file: {:?}", file_path.display());
                        file = Some(tokio::fs::File::create(&file_path).await.map_err(|e| {
                            error!("create file error: {:?}", e);
                            Status::internal(format!("Failed to create file: {}", e))
                        })?);
                        tx.send(Ok(UploadFileResp {})).await.unwrap();
                    }
                    Some(upload_file_request::UploadFileEnum::Content(chunk)) => {
                        // Process file chunk
                        error!("receive upload file chunk");
                        if let Some(file) = file.as_mut() {
                            let res = file.write_all(&chunk).await;
                            error!("write file error: {:?}", res);
                            tx.send(Ok(UploadFileResp {})).await.unwrap();
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

                        break;
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

    pub async fn get_local_ip() -> Result<Ipv4Addr, String> {
        return {
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
    }
    pub async fn discovery(core: Arc<Mutex<JustShareCore>>) {
        let core_clone = core.lock().await;
        let event_to_frontend = core_clone.event_to_frontend_channel.clone().unwrap();

        let local_ip = JustShareCore::get_local_ip();
        let local_ip = local_ip.await.unwrap();

        let socket = UdpSocket::bind("0.0.0.0:9999").await.unwrap();
        let broadcast_addr = "255.255.255.255:9999";
        socket.set_broadcast(true).unwrap();

        let rx = core_clone.discovery_channel_receiver.clone();
        let tx = core_clone.discovery_channel_sender.clone();
        let sender = tx.lock().await;
        let _ = sender.send(()).await;

        error!("server local ip {:}", socket.local_addr().unwrap().ip());
        let my_hostname = core_clone.config.hostname.clone();

        let db = core_clone.discovery_db.clone();
        flutter_rust_bridge::spawn(async move {
            let mut buf: [u8; 1024] = [0; 1024];
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

                        error!("receive raw buf:{:?}",&buf[..number_of_bytes]);
                        let message =
                        match DiscoveryEvent::decode(&buf[..number_of_bytes]){
                            Ok(message) => message,
                            Err(e) =>{
                                 error!("decode message error: {:?}", e);
                                 continue;
                            }
                        };

                        let src_ip = src_addr.ip();
                        error!("Message after decode {:?}", message);
                        let other_hostname:String;
                        match message.discovery_event_enum.unwrap() {
                            DiscoveryEventEnum::DiscoveryReq(DiscoveryReq {self_hostname}) => {
                                error!("get discovery req from: {:?}", src_addr);
                                let resp = DiscoveryEvent{discovery_event_enum:Some(
                                    discovery_event::DiscoveryEventEnum::DiscoveryResp(DiscoveryResp{
                                        self_hostname:my_hostname.clone(),
                                }))};
                                let mut buf = vec![];
                                resp.encode(&mut buf).unwrap();
                                let res = socket.send_to(&buf, src_addr).await;
                                error!("send hello res: {:?} to {:?}", res,src_addr);
                                other_hostname = self_hostname;
                            }

                            DiscoveryEventEnum::DiscoveryResp(  DiscoveryResp { self_hostname:hostname}) => {
                                error!("discovery hostname:{:?} ip: {:?}", hostname,src_ip);
                                other_hostname = hostname;
                            }
                        }
                        error!("wait for db lock ");
                        let mut db = db.lock().await;
                        error!("get db lock ");

                        if let Some(ip) = db.get(&other_hostname) {
                            error!("had receive from ip: {}", ip);
                            continue
                        }

                        db.insert(other_hostname.clone(), src_ip.to_string());

                        // Send the message to the frontend
                        let event = Event {
                        event_enum: Some(event::EventEnum::DiscoveryIp(
                        crate::api::command::DiscoveryIp {
                            addr: src_ip.to_string(),
                            hostname:other_hostname,
                        },
                         )),
                        };
                        let _ = event_to_frontend.add(event);
                    }

                    Some(()) =rx.recv() => {
                        error!("discovery request");
                        {
                            let mut db = db.lock().await;
                            db.clear();
                        }
                                    // Send a discovery message
                            let discovery_message = DiscoveryEvent{discovery_event_enum:Some(
                            discovery_event::DiscoveryEventEnum::DiscoveryReq(DiscoveryReq{
                                self_hostname:my_hostname.clone(),
                            }))};
                            let mut buf = vec![];
                            discovery_message.encode(&mut buf).unwrap();
                            let result = socket
                            .send_to(&buf, &broadcast_addr)
                            .await;
                            error!(" send discovery result: {:?} ", result,);
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
        let _res = JUSTSHARE_CORE
            .do_receive_file(stream, tx, from.to_string())
            .await;

        // echo just write the same data that was received
        let out_stream = ReceiverStream::new(rx);

        Ok(Response::new(Box::pin(out_stream) as Self::UploadFileStream))
    }

    async fn request_accept_file(
        &self,
        request: Request<RequestAcceptFileReq>,
    ) -> std::result::Result<Response<RequestAcceptFileResp>, Status> {
        let from = request.remote_addr().unwrap();
        let req = request.into_inner();
        error!("do_receive_file upload file");
        let core_clone = JUSTSHARE_CORE.core.clone(); // Create a clone of the Arc
        error!("do_receive_file upload file wait lock");
        // let db
        let db: Arc<Mutex<HashMap<String, Arc<Sender<bool>>>>>;
        let event_to_frontend_channel: StreamSink<Event>;
        {
            let core_lock = core_clone.lock().await;
            error!("do_receive_file upload file get lock");
            db = core_lock.comfirm_receive_db.clone();
            event_to_frontend_channel = core_lock.event_to_frontend_channel.clone().unwrap();
        }
        JustShareCore::do_requset_accept_file_to_frontend(
            db,
            event_to_frontend_channel,
            req,
            from.to_string(),
        )
        .await
    }
}

#[derive(Clone)]
pub struct JustShareCoreConfig {
    pub port: u16,
    pub hostname: String,
    pub save_directory: String,
}
