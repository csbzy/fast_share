use crate::api::command::{Receive, Resp, SendFile, Start, Stop};
use lazy_static::lazy_static;
use log::{debug, error, info, log_enabled, Level};
use md5;
use std::sync::Arc;
use tokio::{
    io::{self, AsyncReadExt, AsyncWriteExt},
    net::{TcpListener, TcpStream},
    sync::{
        mpsc::{self, Receiver, Sender},
        Mutex,
    },
};

lazy_static! {
    static ref JUSTSHARE_CORE: MutexJustShareCore = MutexJustShareCore::new();
}

struct MutexJustShareCore {
    core: std::sync::Arc<Mutex<Option<JustShareCore>>>,
    runtime: AFPluginRuntime,
}

async fn start() {
    env_logger::init();
    error!("start justshare core");
    JUSTSHARE_CORE.runtime.spawn(JUSTSHARE_CORE.handle_rx());
}

pub async fn init_core() {
    *JUSTSHARE_CORE.core.lock().await =
        Some(JustShareCore::new(JustShareCoreConfig { port: 8965 }));
    start().await;
}

pub async fn stop() {
    JUSTSHARE_CORE.core.lock().await.take();
}

pub async fn send_file(message: SendFile) {
    JUSTSHARE_CORE.send_file(message).await;
}

pub async fn receive_file() {
    let _ = JUSTSHARE_CORE
        .core
        .lock()
        .await
        .as_mut()
        .unwrap()
        .sender
        .lock()
        .await
        .send("receive".to_string())
        .await;
}

impl MutexJustShareCore {
    fn new() -> Self {
        Self {
            core: Arc::new(Mutex::new(None)),
            runtime: AFPluginRuntime::new().unwrap(),
        }
    }

    async fn send_file(&self, message: SendFile) {
        let core_clone = Arc::clone(&self.core); // Create a clone of the Arc
        self.runtime
            .spawn(async move {
                let mut core_lock = core_clone.lock().await; // Use the cloned Arc inside the async block
                let core: &mut JustShareCore = core_lock.as_mut().unwrap();
                let _ = core.send(message).await;
            })
            .await
            .unwrap();
    }

    async fn handle_receive_file(&self) {
        let core_clone = Arc::clone(&self.core); // Create a clone of the Arc
        self.runtime
            .spawn(async move {
                let mut core_lock = core_clone.lock().await; // Use the cloned Arc inside the async block
                let core: &mut JustShareCore = core_lock.as_mut().unwrap();
                core.receive().await;
            })
            .await
            .unwrap();
    }
    async fn handle_rx(&self) {
        let mut core_lock = self.core.lock().await;
        let core: &mut JustShareCore = core_lock.as_mut().unwrap();

        let mut receiver = core.receiver.lock().await;
        error!("start to hand message");
        loop {
            match receiver.recv().await {
                Some(c) => {
                    error!("receive: {c}");
                    self.handle_receive_file().await;
                }
                None => {}
            }
        }
    }
}
struct JustShareCore {
    pub config: JustShareCoreConfig,
    pub sender: Arc<Mutex<Sender<String>>>,
    pub receiver: Arc<Mutex<Receiver<String>>>,
    pub listener: Arc<Mutex<Option<tokio::net::TcpListener>>>,
}

impl JustShareCore {
    fn new(config: JustShareCoreConfig) -> Self {
        let (sender, receiver) = mpsc::channel(32);
        let sender = Arc::new(Mutex::new(sender));
        let receiver = Arc::new(Mutex::new(receiver));
        let c = Self {
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
        let mut stream = TcpStream::connect(message.addr).await.unwrap();
        self.send_file(&mut stream, &message.path).await
    }

    async fn receive(&mut self) {
        let lis = TcpListener::bind("0.0.0.0:".to_owned() + &self.config.port.to_string()).await;
        match lis {
            Ok(l) => {
                *self.listener.lock().await = Some(l);
            }
            Err(m) => panic!("{}", m),
        }
        loop {
            let stream = self.listener.lock().await.as_ref().unwrap().accept().await;
            let mut mut_stream = stream.unwrap().0;
            let res = self.receive_file(&mut mut_stream).await;
            // println!("res: {res.unwrap()}");
        }
    }

    async fn send_file(&mut self, stream: &mut TcpStream, file_path: &str) -> io::Result<()> {
        let mut file = tokio::fs::File::open(file_path).await?;

        // Compute MD5 checksum of the file.
        let md5_checksum = md5::compute(tokio::fs::read(file_path).await?);
        let file_name = file_path.split("/").last().unwrap_or_default();
        let file_metadata = file.metadata().await?;
        let file_size = file_metadata.len();

        // Send file name, file size, and MD5 checksum.
        stream.write_all(file_name.as_bytes()).await?;
        stream.write_all(&file_size.to_le_bytes()).await?;
        stream.write_all(&md5_checksum.0).await?;

        // Send the file content.
        let mut buffer = vec![0; 1024];
        loop {
            let n = file.read(&mut buffer).await?;
            if n == 0 {
                break;
            }
            stream.write_all(&buffer[..n]).await?;
        }

        Ok(())
    }

    async fn receive_file(&self, stream: &mut TcpStream) -> io::Result<()> {
        let mut file_name_buf = vec![0; 256]; // Assuming file name won't be longer than 256 bytes.
        let mut file_size_buf = [0; 8];
        let mut md5_buf = [0; 16];

        // Read the file name, file size, and MD5 checksum from the stream.
        stream.read_exact(&mut file_name_buf).await?;
        stream.read_exact(&mut file_size_buf).await?;
        stream.read_exact(&mut md5_buf).await?;

        let file_name = String::from_utf8_lossy(&file_name_buf);
        let file_size = u64::from_le_bytes(file_size_buf);
        let expected_md5 = md5::Digest(md5_buf);

        // Read the file content.
        let path = format!("/tmp{}", file_name.trim_matches(char::from(0)));
        let mut file = tokio::fs::File::create(path).await?;
        let mut total_bytes_read = 0;
        let mut buffer = vec![0; 1024];
        let mut file_data = Vec::new();
        while total_bytes_read < file_size {
            let n = stream.read(&mut buffer).await?;
            if n == 0 {
                break;
            }
            file_data.extend_from_slice(&buffer[..n]);
            file.write_all(&buffer[..n]).await?;
            total_bytes_read += n as u64;
        }

        // Verify MD5 checksum.
        let computed_md5 = md5::compute(&file_data);
        if computed_md5 != expected_md5 {
            return Err(io::Error::new(io::ErrorKind::Other, "MD5 mismatch"));
        }

        Ok(())
    }
}
#[derive(Clone)]
struct JustShareCoreConfig {
    pub port: u16,
}

use std::fmt::{Display, Formatter};
use std::future::Future;

use tokio::runtime::Runtime;
use tokio::task::JoinHandle;

struct AFPluginRuntime {
    pub(crate) inner: Runtime,
    #[cfg(feature = "single_thread")]
    local: tokio::task::LocalSet,
}

impl Display for AFPluginRuntime {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        if cfg!(feature = "single_thread") {
            write!(f, "Runtime(single_thread)")
        } else {
            write!(f, "Runtime(multi_thread)")
        }
    }
}

impl AFPluginRuntime {
    fn new() -> io::Result<Self> {
        let inner = default_tokio_runtime()?;
        Ok(Self {
            inner,
            #[cfg(feature = "single_thread")]
            local: tokio::task::LocalSet::new(),
        })
    }

    #[cfg(feature = "single_thread")]
    #[track_caller]
    fn spawn<F>(&self, future: F) -> JoinHandle<F::Output>
    where
        F: Future + 'static,
    {
        self.local.spawn_local(future)
    }

    #[cfg(not(feature = "single_thread"))]
    #[track_caller]
    fn spawn<F>(&self, future: F) -> JoinHandle<F::Output>
    where
        F: Future + Send + 'static,
        <F as Future>::Output: Send + 'static,
    {
        self.inner.spawn(future)
    }

    #[cfg(feature = "single_thread")]
    async fn run_until<F>(&self, future: F) -> F::Output
    where
        F: Future,
    {
        self.local.run_until(future).await
    }

    #[cfg(not(feature = "single_thread"))]
    async fn run_until<F>(&self, future: F) -> F::Output
    where
        F: Future,
    {
        future.await
    }

    #[cfg(feature = "single_thread")]
    #[track_caller]
    fn block_on<F>(&self, f: F) -> F::Output
    where
        F: Future,
    {
        self.local.block_on(&self.inner, f)
    }

    #[cfg(not(feature = "single_thread"))]
    #[track_caller]
    fn block_on<F>(&self, f: F) -> F::Output
    where
        F: Future,
    {
        self.inner.block_on(f)
    }
}

#[cfg(feature = "single_thread")]
fn default_tokio_runtime() -> io::Result<Runtime> {
    runtime::Builder::new_current_thread()
        .thread_name("dispatch-rt-st")
        .enable_io()
        .enable_time()
        .build()
}

#[cfg(not(feature = "single_thread"))]
fn default_tokio_runtime() -> io::Result<Runtime> {
    use log::error;
    use tokio::runtime;

    runtime::Builder::new_multi_thread()
        .thread_name("dispatch-rt-mt")
        .enable_io()
        .enable_time()
        .on_thread_start(move || {
            error!("{:?} thread started", std::thread::current(),);
        })
        .on_thread_stop(move || {
            error!("{:?} thread stopping", std::thread::current(),);
        })
        .build()
}
