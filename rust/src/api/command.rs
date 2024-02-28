/// command between dart <-> rust
/// 启动rust的服务
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct Start {}
/// 停止rust的服务
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct Stop {}
///
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct RequestToReceive {
    #[prost(string, tag = "1")]
    pub file_name: ::prost::alloc::string::String,
    #[prost(string, tag = "2")]
    pub from: ::prost::alloc::string::String,
    #[prost(int32, tag = "3")]
    pub file_num: i32,
}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct SendFile {
    #[prost(string, repeated, tag = "1")]
    pub path: ::prost::alloc::vec::Vec<::prost::alloc::string::String>,
    #[prost(string, tag = "2")]
    pub addr: ::prost::alloc::string::String,
}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct Resp {
    #[prost(int32, tag = "1")]
    pub code: i32,
    #[prost(string, tag = "2")]
    pub msg: ::prost::alloc::string::String,
}
///
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct StartToReceive {}
///
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct Event {
    #[prost(oneof = "event::EventEnum", tags = "1, 2, 3, 4, 5, 6, 7")]
    pub event_enum: ::core::option::Option<event::EventEnum>,
}
/// Nested message and enum types in `Event`.
pub mod event {
    #[allow(clippy::derive_partial_eq_without_eq)]
    #[derive(Clone, PartialEq, ::prost::Oneof)]
    pub enum EventEnum {
        #[prost(message, tag = "1")]
        Start(super::Start),
        #[prost(message, tag = "2")]
        Stop(super::Stop),
        #[prost(message, tag = "3")]
        RequestToReceive(super::RequestToReceive),
        #[prost(message, tag = "4")]
        SendFile(super::SendFile),
        #[prost(message, tag = "5")]
        StartReceive(super::StartToReceive),
        #[prost(message, tag = "6")]
        DiscoveryIp(super::DiscoveryIp),
        #[prost(message, tag = "7")]
        FileProgress(super::FileProgress),
    }
}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct FileProgress {
    #[prost(string, tag = "1")]
    pub file_name: ::prost::alloc::string::String,
    #[prost(int32, tag = "2")]
    pub file_progress: i32,
    #[prost(bool, tag = "3")]
    pub is_error: bool,
    #[prost(double, tag = "4")]
    pub speed: f64,
    /// 0 上传 1 下载
    #[prost(int32, tag = "5")]
    pub progress_type: i32,
}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct DiscoveryIp {
    #[prost(string, tag = "1")]
    pub addr: ::prost::alloc::string::String,
    #[prost(string, tag = "2")]
    pub hostname: ::prost::alloc::string::String,
}
/// UDP Discovery
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct DiscoveryEvent {
    #[prost(oneof = "discovery_event::DiscoveryEventEnum", tags = "1, 2")]
    pub discovery_event_enum: ::core::option::Option<
        discovery_event::DiscoveryEventEnum,
    >,
}
/// Nested message and enum types in `DiscoveryEvent`.
pub mod discovery_event {
    #[allow(clippy::derive_partial_eq_without_eq)]
    #[derive(Clone, PartialEq, ::prost::Oneof)]
    pub enum DiscoveryEventEnum {
        #[prost(message, tag = "1")]
        DiscoveryReq(super::DiscoveryReq),
        #[prost(message, tag = "2")]
        DiscoveryResp(super::DiscoveryResp),
    }
}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct DiscoveryReq {
    #[prost(string, tag = "1")]
    pub self_hostname: ::prost::alloc::string::String,
}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct DiscoveryResp {
    #[prost(string, tag = "1")]
    pub self_hostname: ::prost::alloc::string::String,
}
/// 上传文件,rust层之间通信
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct UploadFileRequest {
    #[prost(oneof = "upload_file_request::UploadFileEnum", tags = "2, 3, 4")]
    pub upload_file_enum: ::core::option::Option<upload_file_request::UploadFileEnum>,
}
/// Nested message and enum types in `UploadFileRequest`.
pub mod upload_file_request {
    #[allow(clippy::derive_partial_eq_without_eq)]
    #[derive(Clone, PartialEq, ::prost::Oneof)]
    pub enum UploadFileEnum {
        #[prost(message, tag = "2")]
        MetaData(super::FileMetaData),
        #[prost(bytes, tag = "3")]
        Content(::prost::alloc::vec::Vec<u8>),
        #[prost(message, tag = "4")]
        Finish(super::Finish),
    }
}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct RequestAcceptFileReq {
    #[prost(string, tag = "1")]
    pub first_file_name: ::prost::alloc::string::String,
    #[prost(int32, tag = "2")]
    pub file_num: i32,
}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct RequestAcceptFileResp {
    #[prost(bool, tag = "1")]
    pub accept: bool,
}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct UploadFileResp {}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct Finish {}
#[allow(clippy::derive_partial_eq_without_eq)]
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct FileMetaData {
    #[prost(string, tag = "1")]
    pub file_name: ::prost::alloc::string::String,
    #[prost(uint64, tag = "2")]
    pub file_size: u64,
    #[prost(string, tag = "3")]
    pub md5: ::prost::alloc::string::String,
}
/// Generated client implementations.
pub mod share_file_client {
    #![allow(unused_variables, dead_code, missing_docs, clippy::let_unit_value)]
    use tonic::codegen::*;
    use tonic::codegen::http::Uri;
    #[derive(Debug, Clone)]
    pub struct ShareFileClient<T> {
        inner: tonic::client::Grpc<T>,
    }
    impl ShareFileClient<tonic::transport::Channel> {
        /// Attempt to create a new client by connecting to a given endpoint.
        pub async fn connect<D>(dst: D) -> Result<Self, tonic::transport::Error>
        where
            D: TryInto<tonic::transport::Endpoint>,
            D::Error: Into<StdError>,
        {
            let conn = tonic::transport::Endpoint::new(dst)?.connect().await?;
            Ok(Self::new(conn))
        }
    }
    impl<T> ShareFileClient<T>
    where
        T: tonic::client::GrpcService<tonic::body::BoxBody>,
        T::Error: Into<StdError>,
        T::ResponseBody: Body<Data = Bytes> + Send + 'static,
        <T::ResponseBody as Body>::Error: Into<StdError> + Send,
    {
        pub fn new(inner: T) -> Self {
            let inner = tonic::client::Grpc::new(inner);
            Self { inner }
        }
        pub fn with_origin(inner: T, origin: Uri) -> Self {
            let inner = tonic::client::Grpc::with_origin(inner, origin);
            Self { inner }
        }
        pub fn with_interceptor<F>(
            inner: T,
            interceptor: F,
        ) -> ShareFileClient<InterceptedService<T, F>>
        where
            F: tonic::service::Interceptor,
            T::ResponseBody: Default,
            T: tonic::codegen::Service<
                http::Request<tonic::body::BoxBody>,
                Response = http::Response<
                    <T as tonic::client::GrpcService<tonic::body::BoxBody>>::ResponseBody,
                >,
            >,
            <T as tonic::codegen::Service<
                http::Request<tonic::body::BoxBody>,
            >>::Error: Into<StdError> + Send + Sync,
        {
            ShareFileClient::new(InterceptedService::new(inner, interceptor))
        }
        /// Compress requests with the given encoding.
        ///
        /// This requires the server to support it otherwise it might respond with an
        /// error.
        #[must_use]
        pub fn send_compressed(mut self, encoding: CompressionEncoding) -> Self {
            self.inner = self.inner.send_compressed(encoding);
            self
        }
        /// Enable decompressing responses.
        #[must_use]
        pub fn accept_compressed(mut self, encoding: CompressionEncoding) -> Self {
            self.inner = self.inner.accept_compressed(encoding);
            self
        }
        /// Limits the maximum size of a decoded message.
        ///
        /// Default: `4MB`
        #[must_use]
        pub fn max_decoding_message_size(mut self, limit: usize) -> Self {
            self.inner = self.inner.max_decoding_message_size(limit);
            self
        }
        /// Limits the maximum size of an encoded message.
        ///
        /// Default: `usize::MAX`
        #[must_use]
        pub fn max_encoding_message_size(mut self, limit: usize) -> Self {
            self.inner = self.inner.max_encoding_message_size(limit);
            self
        }
        pub async fn request_accept_file(
            &mut self,
            request: impl tonic::IntoRequest<super::RequestAcceptFileReq>,
        ) -> std::result::Result<
            tonic::Response<super::RequestAcceptFileResp>,
            tonic::Status,
        > {
            self.inner
                .ready()
                .await
                .map_err(|e| {
                    tonic::Status::new(
                        tonic::Code::Unknown,
                        format!("Service was not ready: {}", e.into()),
                    )
                })?;
            let codec = tonic::codec::ProstCodec::default();
            let path = http::uri::PathAndQuery::from_static(
                "/command.ShareFile/RequestAcceptFile",
            );
            let mut req = request.into_request();
            req.extensions_mut()
                .insert(GrpcMethod::new("command.ShareFile", "RequestAcceptFile"));
            self.inner.unary(req, path, codec).await
        }
        pub async fn upload_file(
            &mut self,
            request: impl tonic::IntoStreamingRequest<Message = super::UploadFileRequest>,
        ) -> std::result::Result<
            tonic::Response<tonic::codec::Streaming<super::UploadFileResp>>,
            tonic::Status,
        > {
            self.inner
                .ready()
                .await
                .map_err(|e| {
                    tonic::Status::new(
                        tonic::Code::Unknown,
                        format!("Service was not ready: {}", e.into()),
                    )
                })?;
            let codec = tonic::codec::ProstCodec::default();
            let path = http::uri::PathAndQuery::from_static(
                "/command.ShareFile/UploadFile",
            );
            let mut req = request.into_streaming_request();
            req.extensions_mut()
                .insert(GrpcMethod::new("command.ShareFile", "UploadFile"));
            self.inner.streaming(req, path, codec).await
        }
    }
}
/// Generated server implementations.
pub mod share_file_server {
    #![allow(unused_variables, dead_code, missing_docs, clippy::let_unit_value)]
    use tonic::codegen::*;
    /// Generated trait containing gRPC methods that should be implemented for use with ShareFileServer.
    #[async_trait]
    pub trait ShareFile: Send + Sync + 'static {
        async fn request_accept_file(
            &self,
            request: tonic::Request<super::RequestAcceptFileReq>,
        ) -> std::result::Result<
            tonic::Response<super::RequestAcceptFileResp>,
            tonic::Status,
        >;
        /// Server streaming response type for the UploadFile method.
        type UploadFileStream: tonic::codegen::tokio_stream::Stream<
                Item = std::result::Result<super::UploadFileResp, tonic::Status>,
            >
            + Send
            + 'static;
        async fn upload_file(
            &self,
            request: tonic::Request<tonic::Streaming<super::UploadFileRequest>>,
        ) -> std::result::Result<tonic::Response<Self::UploadFileStream>, tonic::Status>;
    }
    #[derive(Debug)]
    pub struct ShareFileServer<T: ShareFile> {
        inner: _Inner<T>,
        accept_compression_encodings: EnabledCompressionEncodings,
        send_compression_encodings: EnabledCompressionEncodings,
        max_decoding_message_size: Option<usize>,
        max_encoding_message_size: Option<usize>,
    }
    struct _Inner<T>(Arc<T>);
    impl<T: ShareFile> ShareFileServer<T> {
        pub fn new(inner: T) -> Self {
            Self::from_arc(Arc::new(inner))
        }
        pub fn from_arc(inner: Arc<T>) -> Self {
            let inner = _Inner(inner);
            Self {
                inner,
                accept_compression_encodings: Default::default(),
                send_compression_encodings: Default::default(),
                max_decoding_message_size: None,
                max_encoding_message_size: None,
            }
        }
        pub fn with_interceptor<F>(
            inner: T,
            interceptor: F,
        ) -> InterceptedService<Self, F>
        where
            F: tonic::service::Interceptor,
        {
            InterceptedService::new(Self::new(inner), interceptor)
        }
        /// Enable decompressing requests with the given encoding.
        #[must_use]
        pub fn accept_compressed(mut self, encoding: CompressionEncoding) -> Self {
            self.accept_compression_encodings.enable(encoding);
            self
        }
        /// Compress responses with the given encoding, if the client supports it.
        #[must_use]
        pub fn send_compressed(mut self, encoding: CompressionEncoding) -> Self {
            self.send_compression_encodings.enable(encoding);
            self
        }
        /// Limits the maximum size of a decoded message.
        ///
        /// Default: `4MB`
        #[must_use]
        pub fn max_decoding_message_size(mut self, limit: usize) -> Self {
            self.max_decoding_message_size = Some(limit);
            self
        }
        /// Limits the maximum size of an encoded message.
        ///
        /// Default: `usize::MAX`
        #[must_use]
        pub fn max_encoding_message_size(mut self, limit: usize) -> Self {
            self.max_encoding_message_size = Some(limit);
            self
        }
    }
    impl<T, B> tonic::codegen::Service<http::Request<B>> for ShareFileServer<T>
    where
        T: ShareFile,
        B: Body + Send + 'static,
        B::Error: Into<StdError> + Send + 'static,
    {
        type Response = http::Response<tonic::body::BoxBody>;
        type Error = std::convert::Infallible;
        type Future = BoxFuture<Self::Response, Self::Error>;
        fn poll_ready(
            &mut self,
            _cx: &mut Context<'_>,
        ) -> Poll<std::result::Result<(), Self::Error>> {
            Poll::Ready(Ok(()))
        }
        fn call(&mut self, req: http::Request<B>) -> Self::Future {
            let inner = self.inner.clone();
            match req.uri().path() {
                "/command.ShareFile/RequestAcceptFile" => {
                    #[allow(non_camel_case_types)]
                    struct RequestAcceptFileSvc<T: ShareFile>(pub Arc<T>);
                    impl<
                        T: ShareFile,
                    > tonic::server::UnaryService<super::RequestAcceptFileReq>
                    for RequestAcceptFileSvc<T> {
                        type Response = super::RequestAcceptFileResp;
                        type Future = BoxFuture<
                            tonic::Response<Self::Response>,
                            tonic::Status,
                        >;
                        fn call(
                            &mut self,
                            request: tonic::Request<super::RequestAcceptFileReq>,
                        ) -> Self::Future {
                            let inner = Arc::clone(&self.0);
                            let fut = async move {
                                <T as ShareFile>::request_accept_file(&inner, request).await
                            };
                            Box::pin(fut)
                        }
                    }
                    let accept_compression_encodings = self.accept_compression_encodings;
                    let send_compression_encodings = self.send_compression_encodings;
                    let max_decoding_message_size = self.max_decoding_message_size;
                    let max_encoding_message_size = self.max_encoding_message_size;
                    let inner = self.inner.clone();
                    let fut = async move {
                        let inner = inner.0;
                        let method = RequestAcceptFileSvc(inner);
                        let codec = tonic::codec::ProstCodec::default();
                        let mut grpc = tonic::server::Grpc::new(codec)
                            .apply_compression_config(
                                accept_compression_encodings,
                                send_compression_encodings,
                            )
                            .apply_max_message_size_config(
                                max_decoding_message_size,
                                max_encoding_message_size,
                            );
                        let res = grpc.unary(method, req).await;
                        Ok(res)
                    };
                    Box::pin(fut)
                }
                "/command.ShareFile/UploadFile" => {
                    #[allow(non_camel_case_types)]
                    struct UploadFileSvc<T: ShareFile>(pub Arc<T>);
                    impl<
                        T: ShareFile,
                    > tonic::server::StreamingService<super::UploadFileRequest>
                    for UploadFileSvc<T> {
                        type Response = super::UploadFileResp;
                        type ResponseStream = T::UploadFileStream;
                        type Future = BoxFuture<
                            tonic::Response<Self::ResponseStream>,
                            tonic::Status,
                        >;
                        fn call(
                            &mut self,
                            request: tonic::Request<
                                tonic::Streaming<super::UploadFileRequest>,
                            >,
                        ) -> Self::Future {
                            let inner = Arc::clone(&self.0);
                            let fut = async move {
                                <T as ShareFile>::upload_file(&inner, request).await
                            };
                            Box::pin(fut)
                        }
                    }
                    let accept_compression_encodings = self.accept_compression_encodings;
                    let send_compression_encodings = self.send_compression_encodings;
                    let max_decoding_message_size = self.max_decoding_message_size;
                    let max_encoding_message_size = self.max_encoding_message_size;
                    let inner = self.inner.clone();
                    let fut = async move {
                        let inner = inner.0;
                        let method = UploadFileSvc(inner);
                        let codec = tonic::codec::ProstCodec::default();
                        let mut grpc = tonic::server::Grpc::new(codec)
                            .apply_compression_config(
                                accept_compression_encodings,
                                send_compression_encodings,
                            )
                            .apply_max_message_size_config(
                                max_decoding_message_size,
                                max_encoding_message_size,
                            );
                        let res = grpc.streaming(method, req).await;
                        Ok(res)
                    };
                    Box::pin(fut)
                }
                _ => {
                    Box::pin(async move {
                        Ok(
                            http::Response::builder()
                                .status(200)
                                .header("grpc-status", "12")
                                .header("content-type", "application/grpc")
                                .body(empty_body())
                                .unwrap(),
                        )
                    })
                }
            }
        }
    }
    impl<T: ShareFile> Clone for ShareFileServer<T> {
        fn clone(&self) -> Self {
            let inner = self.inner.clone();
            Self {
                inner,
                accept_compression_encodings: self.accept_compression_encodings,
                send_compression_encodings: self.send_compression_encodings,
                max_decoding_message_size: self.max_decoding_message_size,
                max_encoding_message_size: self.max_encoding_message_size,
            }
        }
    }
    impl<T: ShareFile> Clone for _Inner<T> {
        fn clone(&self) -> Self {
            Self(Arc::clone(&self.0))
        }
    }
    impl<T: std::fmt::Debug> std::fmt::Debug for _Inner<T> {
        fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
            write!(f, "{:?}", self.0)
        }
    }
    impl<T: ShareFile> tonic::server::NamedService for ShareFileServer<T> {
        const NAME: &'static str = "command.ShareFile";
    }
}
