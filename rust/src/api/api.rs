use super::command::Event;
use crate::api::command::SendFile;
use crate::core::core::{JustShareCoreConfig, JUSTSHARE_CORE};
use crate::frb_generated::StreamSink;
use log::{error, LevelFilter};
static INIT: std::sync::Once = std::sync::Once::new();
static RECEIVE: std::sync::Once = std::sync::Once::new();
#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}

pub async fn stop() {}

pub async fn send_file(message: SendFile) {
    JUSTSHARE_CORE.send_file(message).await;
}

pub async fn comfirm_receive_file(name: String) {
    JUSTSHARE_CORE.comfirm_receive_file(name).await;
}

pub async fn refresh_discovery() {
    JUSTSHARE_CORE.refresh_discovery().await;
}

pub async fn init_core(sink: StreamSink<Event>) {
    INIT.call_once(|| {
        error!("init justshare core");

        #[cfg(target_os = "android")]
        android_logger::init_once(
            android_logger::Config::default().with_max_level(LevelFilter::Trace),
        );

        #[cfg(target_os = "ios")]
        oslog::OsLogger::new("com.example.test")
            .level_filter(LevelFilter::Trace)
            .init()
            .unwrap();

        #[cfg(not(target_os = "android"))]
        env_logger::init();

        flutter_rust_bridge::spawn(async move {
            JUSTSHARE_CORE.async_event_to_frontend(sink).await;
            JUSTSHARE_CORE.start_receive_file().await;
            error!("start discovery addr");

            JUSTSHARE_CORE.discovery().await;
        });
    });
}
