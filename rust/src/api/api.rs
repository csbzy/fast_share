use super::command;
use super::core::core::{JustShareCore, JustShareCoreConfig, MutexJustShareCore, JUSTSHARE_CORE};
use crate::api::command::SendFile;
use crate::frb_generated::StreamSink;
use lazy_static::lazy_static;
use log::error;
use md5;
use std::pin::Pin;
use std::sync::atomic::{AtomicI32, Ordering};
use std::sync::Arc;
use std::thread;
use std::time::Duration;
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

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}

pub async fn init_core() {
    *JUSTSHARE_CORE.core.lock().await =
        Some(JustShareCore::new(JustShareCoreConfig { port: 8965 }));
    start();
}

pub async fn start() {
    env_logger::init();
    error!("start justshare core");
    // JUSTSHARE_CORE.runtime.spawn(JUSTSHARE_CORE.handle_rx());
}

pub async fn stop() {
    JUSTSHARE_CORE.core.lock().await.take();
}

pub async fn send_file(message: SendFile) {
    JUSTSHARE_CORE.send_file(message).await;
}

pub async fn receive_file() {
    MutexJustShareCore::handle_receive_file(JUSTSHARE_CORE.core.clone()).await;
}

pub async fn handle_stream(sink: StreamSink<String>) {
    error!("handle_stream arg");

    let cnt = Arc::new(AtomicI32::new(0));

    // just to show that, you can send data to sink even in other threads
    let cnt2 = cnt.clone();
    let sink2 = sink.clone();
    flutter_rust_bridge::spawn(async move {
        for i in 0..5 {
            let old_cnt = cnt2.fetch_add(1, Ordering::Relaxed);
            let msg = format!("(thread=child, i={}, old_cnt={})", i, old_cnt);
            format!("send data to sink msg={}", msg);
            let _ = sink2.add(msg);
            thread::sleep(Duration::from_millis(100));
        }
        // sink2.close();
    });

    for i in 0..5 {
        let old_cnt = cnt.fetch_add(1, Ordering::Relaxed);
        let msg = format!("(thread=normal, i={}, old_cnt={})", i, old_cnt);
        format!("send data to sink msg={}", msg);
        let _ = sink.add(msg);
        thread::sleep(Duration::from_millis(50));
    }

    // Ok(())
}
