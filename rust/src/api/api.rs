use super::command::Event;
use crate::api::command::SendFile;
use crate::core::core::JUSTSHARE_CORE;
use crate::frb_generated::StreamSink;
use log::error;

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}

pub async fn start() {
    env_logger::init();
    error!("start justshare core");
    // flutter_rust_bridge::spawn(JUSTSHARE_CORE.handle_rx());
}

pub async fn stop() {}

pub async fn send_file(message: SendFile) {
    JUSTSHARE_CORE.send_file(message).await;
}

pub async fn receive_file() {
    JUSTSHARE_CORE.start_receive_file().await;
}

pub async fn comfirm_receive_file(name: String) {
    JUSTSHARE_CORE.comfirm_receive_file(name).await;
}

pub async fn handle_stream(sink: StreamSink<Event>) {
    error!("handle_stream arg");
    JUSTSHARE_CORE.async_event_to_frontend(sink).await;
}
