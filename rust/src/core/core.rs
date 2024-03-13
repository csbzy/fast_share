use crate::api::command::*;
use crate::api::command::{
    discovery_event::*, share_file_client::ShareFileClient, share_file_server::*,
    upload_file_request, FileMetaData, SendFile, UploadFileRequest,
};
use crate::api::command::{upload_file_request::UploadFileEnum, Event};
use crate::core::utils;
use crate::frb_generated::StreamSink;
use flutter_rust_bridge::frb;
use lazy_static::lazy_static;
use log::{debug, error};
use socket2::{Domain, Protocol, Socket, Type};

use prost::Message;
use std::collections::HashMap;
use std::fs;
use std::io::Write;
use std::net::{IpAddr, Ipv4Addr, SocketAddr, SocketAddrV4, UdpSocket};
use std::path::PathBuf;
use std::pin::Pin;
use std::sync::Arc;
use tokio::io::AsyncReadExt;
use tokio::net::TcpListener;
use tokio::sync::mpsc;
use tokio::time::Instant;
use tokio::{
    sync::mpsc::{Receiver, Sender},
    sync::Mutex,
};
use tokio_stream::{wrappers::ReceiverStream, Stream};
use tonic::codec::CompressionEncoding;
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
                send_file_worker_num: 5,
            }))), //
        }
    }

    pub async fn send_file(&self, message: SendFile) {
        debug!("enter send file");
        let core_clone = self.core.clone(); // Create a clone of the Arc
        flutter_rust_bridge::spawn(async move {
            debug!("enter send file spawn");
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
        debug!("start refresh discovery wait lock");
        let core_lock = self.core.lock().await;
        debug!("start refresh discovery wait channel lock");

        let tx = core_lock.discovery_channel_sender.lock().await;
        debug!("start refresh discovery send");

        tx.send(()).await.unwrap();
    }

    pub async fn init_core(&self, hostname: String, directory: String) {
        let mut core_lock = self.core.lock().await;
        core_lock.config.hostname = hostname;
        core_lock.config.save_directory = directory;
    }

    pub async fn start_receive_file(&self) {
        debug!("start handle receive file");
        let core_clone = self.core.clone();
        let listener = TcpListener::bind("0.0.0.0:0").await.unwrap();
        let actual_addr = listener.local_addr().unwrap();
        let mut core_lock = core_clone.lock().await;
        core_lock.config.port = actual_addr.port();
        debug!("listen at {}", actual_addr);
        flutter_rust_bridge::spawn(async move {
            debug!("ENTER SPAWN start handle receive file");
            let sf = MyShareFileServer::default();
            // debug!("fileListenServer listening on {}", addr);
            println!("Server listening on: {}", actual_addr);

            Server::builder()
                .add_service(
                    ShareFileServer::new(sf)
                        .accept_compressed(CompressionEncoding::Gzip)
                        .max_decoding_message_size(256 * 1024 * 1024)
                        .max_encoding_message_size(256 * 1024 * 1024),
                )
                .serve_with_incoming(tokio_stream::wrappers::TcpListenerStream::new(listener))
                .await
                .unwrap();

            // let actual_socket_address = server.local_addr();
            debug!("LEAVE SPAWN start handle receive file");
        });

        debug!("unlock core");
    }

    pub async fn comfirm_receive_file(&self, accept: bool, file_name: String) {
        let core_clone = Arc::clone(&self.core);
        debug!("start to get core lock for {:?}", file_name);
        let core = core_clone.lock().await;
        debug!("comfirm_receive_file lock core");
        let db = &core.comfirm_receive_db;
        debug!("start to get db lock");
        let mut db = db.lock().await;
        debug!("db lock get");
        match db.remove(&file_name) {
            Some(comfirm_tx) => {
                let resp = comfirm_tx.send(accept).await; // Ignore the result with let _
                error!("comfirm_receive_file send resp {:?}", resp);
            }

            None => {
                error!("comfirm_receive_file not found");
            }
        }
        debug!("comfirm_receive_file nlock core");
    }

    pub async fn do_receive_file(
        &self,
        stream: Streaming<UploadFileRequest>,
        tx: Sender<Result<UploadFileResp, Status>>,
        from: String,
    ) {
        debug!("do_receive_file upload file");
        let core_clone = Arc::clone(&self.core); // Create a clone of the Arc
        debug!("do_receive_file upload file wait lock");

        let core_lock = core_clone.lock().await;
        debug!("do_receive_file upload file get lock");

        core_lock.do_receive_file(stream, tx, from).await;
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
    pub discovery_db: Arc<Mutex<HashMap<String, (String, String)>>>,
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

    async fn send_file(&self, message: SendFile) {
        debug!("enter core send: {:?}", message);
        let client = ShareFileClient::connect(format!("http://{:}", message.addr.clone())).await;
        let file_paths = message.path.clone();
        debug!("connect server: {:?}", client);

        if file_paths.is_empty() {
            return;
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
            return;
        }

        let file_paths = file_paths.clone();
        let num_threads = self.config.send_file_worker_num;
        let chunk_size = (file_paths.len() + num_threads - 1) / num_threads;

        // 开self.config.send_file_worker_num个线程处理文件
        file_paths.chunks(chunk_size).for_each(|chunk| {
            let chunk: Vec<String> = chunk.to_vec();
            let addr = message.addr.clone();
            let event_to_chanel = self.event_to_frontend_channel.clone().unwrap();

            flutter_rust_bridge::spawn(async move {
                for file_path in chunk {
                    JustShareCore::do_send_file(file_path, addr.clone(), event_to_chanel.clone())
                        .await;
                }
            });
        });
    }

    pub async fn do_send_file(
        file_path: String,
        addr: String,
        event_to_frontend_channel: StreamSink<Event>,
    ) {
        let client = ShareFileClient::connect(format!("http://{:}", addr)).await;
        let path = file_path.clone();
        let mut file = tokio::fs::File::open(path.clone()).await.unwrap();
        let file_metadata = file.metadata().await.unwrap();
        let file_size = file_metadata.len();
        let file_path = file_path.clone();
        let file_name = file_path.split("/").last().unwrap_or_default();

        let request = UploadFileRequest {
            upload_file_enum: Some(UploadFileEnum::MetaData(FileMetaData {
                file_name: file_name.to_string(),
                file_size: file_size,
                md5: utils::calc_md5(&file_path),
            })),
        };

        debug!("start send request: {:?}", request);
        let (tx, rx) = mpsc::channel(5);
        let request_stream = ReceiverStream::new(rx);
        let response = client.unwrap().upload_file(request_stream).await.unwrap();
        let mut resp_stream = response.into_inner();
        let res = tx.send(request).await.unwrap();
        error!(
            "send file meta data res: {:?}, file bytes:{:?}",
            res, file_size
        );
        debug!("finish send request: file meta data",);

        let chunk_size = 3 * 1024 * 1024; // 每包最大30MB
        let mut buffer = vec![0; chunk_size];
        let mut offset: u64 = 0;
        let start_time = std::time::Instant::now();
        while offset < file_size {
            debug!("offset: {:?}, file_size: {:?}", offset, file_size);
            let bytes_to_read =
                std::cmp::min(chunk_size, (file_size - offset).try_into().unwrap()) as usize;
            file.read_exact(&mut buffer[0..bytes_to_read])
                .await
                .unwrap();
            offset += bytes_to_read as u64;
            let file_progress = utils::calc_progress(offset as usize, file_size);

            let elapsed_time = start_time.elapsed();
            let speed_mbps = utils::calc_speed(offset as usize, elapsed_time);

            let res = match tx
                .send(UploadFileRequest {
                    upload_file_enum: Some(UploadFileEnum::Content(
                        buffer[0..bytes_to_read].to_vec(),
                    )),
                })
                .await
            {
                Ok(res) => res,
                Err(e) => {
                    error!("send file content error: {:}", e);
                    JustShareCore::progress_to_frontend(
                        event_to_frontend_channel.clone(),
                        FileProgress {
                            file_name: file_name.to_string(),
                            file_progress: file_progress,
                            is_error: true,
                            speed: speed_mbps,
                            progress_type: utils::ProgressType::Download as i32,
                        },
                    );
                    break;
                }
            };

            debug!("send file content res: {:?}", res);
            let resp = match resp_stream.message().await {
                Ok(resp) => resp,
                Err(e) => {
                    error!("recv upload file resp error: {:}", e);
                    JustShareCore::progress_to_frontend(
                        event_to_frontend_channel.clone(),
                        FileProgress {
                            file_name: file_name.to_string(),
                            file_progress: file_progress,
                            is_error: true,
                            speed: speed_mbps,
                            progress_type: utils::ProgressType::Download as i32,
                        },
                    );
                    break;
                }
            };
            debug!("recv upload file resp: {:?}", resp);

            JustShareCore::progress_to_frontend(
                event_to_frontend_channel.clone(),
                FileProgress {
                    file_name: file_name.to_string(),
                    file_progress: file_progress,
                    is_error: false,
                    speed: speed_mbps,
                    progress_type: utils::ProgressType::Download as i32,
                },
            );
        }

        let res = match tx
            .send(UploadFileRequest {
                upload_file_enum: Some(UploadFileEnum::Finish(Finish {})),
            })
            .await
        {
            Ok(res) => res,
            Err(e) => {
                error!("send file finish error: {:}", e);
            }
        };

        debug!("send file finish res: {:?}", res);
    }

    pub async fn do_requset_accept_file_to_frontend(
        comfirm_receive_db: Arc<Mutex<HashMap<String, Arc<mpsc::Sender<bool>>>>>,
        event_to_frontend_channel: StreamSink<Event>,
        request: RequestAcceptFileReq,
        from: String,
    ) -> Result<Response<RequestAcceptFileResp>, Status> {
        let db = comfirm_receive_db.clone();
        let (comfirm_tx, mut comfirm_rx) = mpsc::channel::<bool>(1);
        debug!("try to lock db");
        db.lock()
            .await
            .insert(request.first_file_name.clone(), Arc::new(comfirm_tx));
        debug!("unlock db");

        debug!("try send event to frontend");
        JustShareCore::event_to_frontend(
            event_to_frontend_channel,
            Event {
                event_enum: Some(event::EventEnum::RequestToReceive(RequestToReceive {
                    file_name: request.first_file_name.clone(),
                    from: from.clone(),
                    file_num: request.file_num,
                })),
            },
        );

        debug!("wait for comfirm response");
        // wait for response
        let s = comfirm_rx.recv().await;

        debug!("get comfirm response: {:?}", s);
        let accept = s.unwrap();

        Ok(Response::new(RequestAcceptFileResp { accept: accept }))
    }

    pub async fn do_receive_file(
        &self,
        mut stream: Streaming<UploadFileRequest>,
        tx: Sender<Result<UploadFileResp, Status>>,
        from: String,
    ) {
        debug!("just share core do to receive upload file from {:}", from);

        debug!("do_receive_file upload file");
        let core_clone = self; // Create a clone of the Arc
        debug!("do_receive_file upload file wait lock");

        debug!("do_receive_file upload file get lock");
        let save_path = core_clone.config.save_directory.clone();
        let event_to_frontend_channel: StreamSink<Event> =
            core_clone.event_to_frontend_channel.clone().unwrap();

        flutter_rust_bridge::spawn(async move {
            debug!("just share core do to receive upload file spawn");
            let mut file = None;
            let mut filename = "".to_string();
            let mut file_size = 0;
            let mut recv_size = 0;
            let start_time = Instant::now();

            loop {
                let recv = stream.message().await;
                let upload = match recv {
                    Ok(upload) => upload.unwrap(),
                    Err(e) => {
                        error!("receive upload file error: {:}", e);
                        JustShareCore::progress_to_frontend(
                            event_to_frontend_channel.clone(),
                            FileProgress {
                                file_name: filename.clone(),
                                file_progress: 0,
                                is_error: true,
                                speed: 0.0,
                                progress_type: utils::ProgressType::Download as i32,
                            },
                        );
                        break;
                    }
                };
                match upload.upload_file_enum {
                    Some(upload_file_request::UploadFileEnum::MetaData(metadata)) => {
                        debug!("receive upload file meta data {:?}", metadata);
                        filename = metadata.file_name.clone();
                        let mut file_path = PathBuf::from(save_path.clone());
                        file_path.push(filename.clone());
                        debug!("start to create file: {:?}", file_path.display());
                        file = match fs::File::create(&file_path) {
                            Ok(file) => {
                                debug!("create file success");
                                Some(file)
                            }
                            Err(e) => {
                                error!("create file error: {:}", e);
                                return Err(Status::internal(format!(
                                    "Failed to create file: {}",
                                    e
                                )));
                            }
                        };
                        debug!("create file success");
                        file_size = metadata.file_size;
                        debug!("BEGIN TO SEND file success");
                        JustShareCore::progress_to_frontend(
                            event_to_frontend_channel.clone(),
                            FileProgress {
                                file_name: filename.clone(),
                                file_progress: 0,
                                is_error: false,
                                speed: 0.0,
                                progress_type: utils::ProgressType::Download as i32,
                            },
                        );

                        let resp = tx.send(Ok(UploadFileResp {})).await;
                        debug!("finish send file resp: {:?}", resp);
                    }
                    Some(upload_file_request::UploadFileEnum::Content(chunk)) => {
                        // Process file chunk
                        debug!("receive upload file chunk");
                        if let Some(file) = file.as_mut() {
                            let res = file.write_all(&chunk);
                            error!("write file error: {:?}", res);

                            recv_size += chunk.len();
                            let file_progress = utils::calc_progress(recv_size, file_size);

                            let elapsed_time = start_time.elapsed();
                            let download_speed_mbps = utils::calc_speed(recv_size, elapsed_time);

                            JustShareCore::progress_to_frontend(
                                event_to_frontend_channel.clone(),
                                FileProgress {
                                    file_name: filename.clone(),
                                    file_progress: file_progress,
                                    is_error: false,
                                    speed: download_speed_mbps,
                                    progress_type: utils::ProgressType::Download as i32,
                                },
                            );
                            match tx.send(Ok(UploadFileResp {})).await {
                                Ok(_) => {}
                                Err(r) => {
                                    error!("send upload file resp error: {:?}", r);
                                }
                            };
                        } else {
                            return Err(Status::failed_precondition("No file metadata provided"));
                        }
                    }
                    Some(upload_file_request::UploadFileEnum::Finish(_)) => {
                        debug!("receive upload file finish");
                        if let Some(file) = file.as_mut() {
                            file.flush().map_err(|e| {
                                Status::internal(format!("Failed to flush file: {}", e))
                            })?;
                            file.sync_all().map_err(|e| {
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
            debug!("stream end");
            Ok(())
        });
    }

    pub async fn get_local_ip() -> Result<Ipv4Addr, String> {
        return {
            let socket1 =
                UdpSocket::bind("0.0.0.0:0").map_err(|e| format!("Failed to bind socket: {}", e));
            let socket1 = socket1.unwrap();

            let _ = socket1
                .connect("8.8.8.8:80")
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
        let core_clone = core.clone(); //core.lock().await;
        let core_lock = core_clone.lock().await;

        let local_ip = JustShareCore::get_local_ip();
        let local_ip = local_ip.await.unwrap();

        // 这是广播逻辑
        // let socket = UdpSocket::bind("0.0.0.0:9999").await.unwrap();
        // let broadcast_addr = "255.255.255.255:9999";
        // socket.set_broadcast(true).unwrap();
        // debug!("server local ip {:}", socket.local_addr().unwrap().ip());

        let socket = Socket::new(Domain::IPV4, Type::DGRAM, Some(Protocol::UDP)).unwrap();
        socket.set_reuse_address(true).unwrap();

        let address: SocketAddr = "0.0.0.0:12345".parse().unwrap();
        socket.bind(&address.into()).unwrap();

        // Convert the socket into a std::net::UdpSocket
        let std_socket = UdpSocket::from(socket);
        let socket = tokio::net::UdpSocket::from_std(std_socket).unwrap();

        // socket.set_multicast_loop_v4(true).unwrap();
        let addr = "224.0.0.251".parse().unwrap();
        let multicast_addr = SocketAddrV4::new(addr, address.port());

        // let interface = Ipv4Addr::new(0, 0, 0, 0);
        socket.join_multicast_v4(addr, local_ip).unwrap();
        socket.set_multicast_loop_v4(true).unwrap();

        let my_hostname = core_lock.config.hostname.clone();

        let rx = core_lock.discovery_channel_receiver.clone();
        let my_listen_port = core_lock.config.port;

        drop(core_lock);

        flutter_rust_bridge::spawn(async move {
            let mut buf: [u8; 1024] = [0; 1024];
            let core_clone = core.clone();
            let mut rx = rx.lock().await;
            loop {
                tokio::select! {
                                    Ok((number_of_bytes,src_addr))=socket.recv_from(&mut buf)=>{
                                        debug!("Received {} bytes from {:?}", number_of_bytes, src_addr);
                                        let src_ip = src_addr.ip();
                                        debug!("srcip: {:?} local_ip: {:?}", src_ip,local_ip);
                                        if src_ip == local_ip{
                                            continue
                                        }

                                        debug!("receive raw buf:{:?}",&buf[..number_of_bytes]);
                                        let message =
                                        match DiscoveryEvent::decode(&buf[..number_of_bytes]){
                                            Ok(message) => message,
                                            Err(e) =>{
                                                 error!("decode message error: {:?}", e);
                                                 continue;
                                            }
                                        };

                                        debug!("wait for db lock ");
                                        let core_lock = core_clone.lock().await;
                                        let event_to_frontend = core_lock.event_to_frontend_channel.clone().unwrap();
                                        let db = core_lock.discovery_db.clone();
                                        let mut db = db.lock().await;
                                        debug!("get db lock ");

                                        let src_ip = src_addr.ip();
                                        debug!("Message after decode {:?}", message);
                                        let other_hostname:String;
                                        let other_listen_port:String ;
                                        match message.discovery_event_enum.unwrap() {
                                            DiscoveryEventEnum::DiscoveryReq(DiscoveryReq {
                                                discovery:Some(Discovery{self_hostname,self_listen_port})} ) => {
                                                debug!("get discovery req from: {:?}", src_addr);
                                                let resp = DiscoveryEvent{discovery_event_enum:Some(
                                                    discovery_event::DiscoveryEventEnum::DiscoveryResp(DiscoveryResp{
                                                        discovery:Some(Discovery{
                                                            self_hostname:my_hostname.clone(),
                                                            self_listen_port:my_listen_port.to_string(),
                                                        })
                                                }))};
                                                let mut buf = vec![];
                                                resp.encode(&mut buf).unwrap();
                                                let res = socket.send_to(&buf, src_addr).await;
                                                debug!("send hello res: {:?} to {:?}", res,src_addr);
                                                other_hostname = self_hostname;
                                                other_listen_port= self_listen_port;
                                            }

                                            DiscoveryEventEnum::DiscoveryResp(  DiscoveryResp { discovery:Some(Discovery{self_hostname,self_listen_port})}) => {
                                                debug!("discovery hostname:{:?} ip: {:?}", self_hostname,src_ip);
                                                other_hostname = self_hostname;
                                                other_listen_port= self_listen_port;

                                            }
                                            _r =>{
                                                error!("unknown message {:?}", _r);
                                                continue;
                                            }
                                        }


                                        db.insert(other_hostname.clone(), (src_ip.to_string(), other_listen_port.to_string()));
                                        let other_addr = src_ip.to_string() + ":" + &other_listen_port;
                                        // Send the message to the frontend
                                        let event = Event {
                                        event_enum: Some(event::EventEnum::DiscoveryIp(
                                        crate::api::command::DiscoveryIp {
                                            addr: other_addr,
                                            hostname:other_hostname,
                                        },
                                         )),
                                        };
                                        JustShareCore::event_to_frontend(event_to_frontend.clone(), event);

                                    }

                                    Some(()) =rx.recv() => {
                                                    // Send a discovery message
                                            let discovery_message = DiscoveryEvent{discovery_event_enum:Some(
                                            discovery_event::DiscoveryEventEnum::DiscoveryReq(DiscoveryReq{
                                                discovery:Some(Discovery{
                                                    self_hostname:my_hostname.clone(),
                                                    self_listen_port: my_listen_port.to_string()}) })
                )};
                                            let mut buf = vec![];
                                            discovery_message.encode(&mut buf).unwrap();
                                            let result = socket
                                            .send_to(&buf, &multicast_addr).await;
                                        debug!(" send discovery result: {:?} ", result,);
                                    }
                                }
            }
        });
    }
    pub fn event_to_frontend(channel: StreamSink<Event>, event: Event) {
        let res = channel.add(event);
        debug!("add event res: {:?}", res);
    }

    pub fn progress_to_frontend(
        event_to_frontend_channel: StreamSink<Event>,
        progress: FileProgress,
    ) {
        JustShareCore::event_to_frontend(
            event_to_frontend_channel,
            Event {
                event_enum: Some(event::EventEnum::FileProgress(progress)),
            },
        );
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
        debug!("start to receive upload file");
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
        debug!("do_receive_file upload file");
        let core_clone = JUSTSHARE_CORE.core.clone(); // Create a clone of the Arc
        debug!("do_receive_file upload file wait lock");
        // let db
        let db: Arc<Mutex<HashMap<String, Arc<Sender<bool>>>>>;
        let event_to_frontend_channel: StreamSink<Event>;
        {
            let core_lock = core_clone.lock().await;
            debug!("do_receive_file upload file get lock");
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
    pub send_file_worker_num: usize,
}
