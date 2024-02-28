// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.24.

// ignore_for_file: unused_import, unused_element, unnecessary_import, duplicate_ignore, invalid_use_of_internal_member, annotate_overrides, non_constant_identifier_names, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables, unused_field

import 'api/api.dart';
import 'api/command.dart';
import 'api/command/event.dart';
import 'dart:async';
import 'dart:convert';
import 'frb_generated.io.dart' if (dart.library.html) 'frb_generated.web.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

/// Main entrypoint of the Rust API
class RustLib extends BaseEntrypoint<RustLibApi, RustLibApiImpl, RustLibWire> {
  @internal
  static final instance = RustLib._();

  RustLib._();

  /// Initialize flutter_rust_bridge
  static Future<void> init({
    RustLibApi? api,
    BaseHandler? handler,
    ExternalLibrary? externalLibrary,
  }) async {
    await instance.initImpl(
      api: api,
      handler: handler,
      externalLibrary: externalLibrary,
    );
  }

  /// Dispose flutter_rust_bridge
  ///
  /// The call to this function is optional, since flutter_rust_bridge (and everything else)
  /// is automatically disposed when the app stops.
  static void dispose() => instance.disposeImpl();

  @override
  ApiImplConstructor<RustLibApiImpl, RustLibWire> get apiImplConstructor =>
      RustLibApiImpl.new;

  @override
  WireConstructor<RustLibWire> get wireConstructor =>
      RustLibWire.fromExternalLibrary;

  @override
  Future<void> executeRustInitializers() async {
    await api.initApp();
  }

  @override
  ExternalLibraryLoaderConfig get defaultExternalLibraryLoaderConfig =>
      kDefaultExternalLibraryLoaderConfig;

  @override
  String get codegenVersion => '2.0.0-dev.24';

  static const kDefaultExternalLibraryLoaderConfig =
      ExternalLibraryLoaderConfig(
    stem: 'rust_lib_just_share',
    ioDirectory: 'rust/target/release/',
    webPrefix: 'pkg/',
  );
}

abstract class RustLibApi extends BaseApi {
  Future<void> comfirmReceiveFile(
      {required bool accept, required String file, dynamic hint});

  Future<void> initApp({dynamic hint});

  Stream<Event> initCore(
      {required String hostname, required String directory, dynamic hint});

  Future<void> refreshDiscovery({dynamic hint});

  Future<void> sendFile({required SendFile message, dynamic hint});

  Future<void> stop({dynamic hint});
}

class RustLibApiImpl extends RustLibApiImplPlatform implements RustLibApi {
  RustLibApiImpl({
    required super.handler,
    required super.wire,
    required super.generalizedFrbRustBinding,
    required super.portManager,
  });

  @override
  Future<void> comfirmReceiveFile(
      {required bool accept, required String file, dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_bool(accept, serializer);
        sse_encode_String(file, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 4, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kComfirmReceiveFileConstMeta,
      argValues: [accept, file],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kComfirmReceiveFileConstMeta => const TaskConstMeta(
        debugName: "comfirm_receive_file",
        argNames: ["accept", "file"],
      );

  @override
  Future<void> initApp({dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 1, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kInitAppConstMeta,
      argValues: [],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kInitAppConstMeta => const TaskConstMeta(
        debugName: "init_app",
        argNames: [],
      );

  @override
  Stream<Event> initCore(
      {required String hostname, required String directory, dynamic hint}) {
    return handler.executeStream(StreamTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_String(hostname, serializer);
        sse_encode_String(directory, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 6, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_event,
        decodeErrorData: null,
      ),
      constMeta: kInitCoreConstMeta,
      argValues: [hostname, directory],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kInitCoreConstMeta => const TaskConstMeta(
        debugName: "init_core",
        argNames: ["hostname", "directory"],
      );

  @override
  Future<void> refreshDiscovery({dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 5, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kRefreshDiscoveryConstMeta,
      argValues: [],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kRefreshDiscoveryConstMeta => const TaskConstMeta(
        debugName: "refresh_discovery",
        argNames: [],
      );

  @override
  Future<void> sendFile({required SendFile message, dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_box_autoadd_send_file(message, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 3, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kSendFileConstMeta,
      argValues: [message],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kSendFileConstMeta => const TaskConstMeta(
        debugName: "send_file",
        argNames: ["message"],
      );

  @override
  Future<void> stop({dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 2, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kStopConstMeta,
      argValues: [],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kStopConstMeta => const TaskConstMeta(
        debugName: "stop",
        argNames: [],
      );

  @protected
  String dco_decode_String(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as String;
  }

  @protected
  bool dco_decode_bool(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as bool;
  }

  @protected
  DiscoveryIp dco_decode_box_autoadd_discovery_ip(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return dco_decode_discovery_ip(raw);
  }

  @protected
  EventEnum dco_decode_box_autoadd_event_enum(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return dco_decode_event_enum(raw);
  }

  @protected
  FileProgress dco_decode_box_autoadd_file_progress(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return dco_decode_file_progress(raw);
  }

  @protected
  RequestToReceive dco_decode_box_autoadd_request_to_receive(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return dco_decode_request_to_receive(raw);
  }

  @protected
  SendFile dco_decode_box_autoadd_send_file(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return dco_decode_send_file(raw);
  }

  @protected
  Start dco_decode_box_autoadd_start(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return dco_decode_start(raw);
  }

  @protected
  StartToReceive dco_decode_box_autoadd_start_to_receive(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return dco_decode_start_to_receive(raw);
  }

  @protected
  Stop dco_decode_box_autoadd_stop(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return dco_decode_stop(raw);
  }

  @protected
  DiscoveryIp dco_decode_discovery_ip(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    final arr = raw as List<dynamic>;
    if (arr.length != 2)
      throw Exception('unexpected arr length: expect 2 but see ${arr.length}');
    return DiscoveryIp(
      addr: dco_decode_String(arr[0]),
      hostname: dco_decode_String(arr[1]),
    );
  }

  @protected
  Event dco_decode_event(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    final arr = raw as List<dynamic>;
    if (arr.length != 1)
      throw Exception('unexpected arr length: expect 1 but see ${arr.length}');
    return Event(
      eventEnum: dco_decode_opt_box_autoadd_event_enum(arr[0]),
    );
  }

  @protected
  EventEnum dco_decode_event_enum(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    switch (raw[0]) {
      case 0:
        return EventEnum_Start(
          dco_decode_box_autoadd_start(raw[1]),
        );
      case 1:
        return EventEnum_Stop(
          dco_decode_box_autoadd_stop(raw[1]),
        );
      case 2:
        return EventEnum_RequestToReceive(
          dco_decode_box_autoadd_request_to_receive(raw[1]),
        );
      case 3:
        return EventEnum_SendFile(
          dco_decode_box_autoadd_send_file(raw[1]),
        );
      case 4:
        return EventEnum_StartReceive(
          dco_decode_box_autoadd_start_to_receive(raw[1]),
        );
      case 5:
        return EventEnum_DiscoveryIp(
          dco_decode_box_autoadd_discovery_ip(raw[1]),
        );
      case 6:
        return EventEnum_FileProgress(
          dco_decode_box_autoadd_file_progress(raw[1]),
        );
      default:
        throw Exception("unreachable");
    }
  }

  @protected
  double dco_decode_f_64(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as double;
  }

  @protected
  FileProgress dco_decode_file_progress(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    final arr = raw as List<dynamic>;
    if (arr.length != 5)
      throw Exception('unexpected arr length: expect 5 but see ${arr.length}');
    return FileProgress(
      fileName: dco_decode_String(arr[0]),
      fileProgress: dco_decode_i_32(arr[1]),
      isError: dco_decode_bool(arr[2]),
      speed: dco_decode_f_64(arr[3]),
      progressType: dco_decode_i_32(arr[4]),
    );
  }

  @protected
  int dco_decode_i_32(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as int;
  }

  @protected
  List<String> dco_decode_list_String(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return (raw as List<dynamic>).map(dco_decode_String).toList();
  }

  @protected
  Uint8List dco_decode_list_prim_u_8_strict(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as Uint8List;
  }

  @protected
  EventEnum? dco_decode_opt_box_autoadd_event_enum(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw == null ? null : dco_decode_box_autoadd_event_enum(raw);
  }

  @protected
  RequestToReceive dco_decode_request_to_receive(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    final arr = raw as List<dynamic>;
    if (arr.length != 3)
      throw Exception('unexpected arr length: expect 3 but see ${arr.length}');
    return RequestToReceive(
      fileName: dco_decode_String(arr[0]),
      from: dco_decode_String(arr[1]),
      fileNum: dco_decode_i_32(arr[2]),
    );
  }

  @protected
  SendFile dco_decode_send_file(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    final arr = raw as List<dynamic>;
    if (arr.length != 2)
      throw Exception('unexpected arr length: expect 2 but see ${arr.length}');
    return SendFile(
      path: dco_decode_list_String(arr[0]),
      addr: dco_decode_String(arr[1]),
    );
  }

  @protected
  Start dco_decode_start(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    final arr = raw as List<dynamic>;
    if (arr.length != 0)
      throw Exception('unexpected arr length: expect 0 but see ${arr.length}');
    return Start();
  }

  @protected
  StartToReceive dco_decode_start_to_receive(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    final arr = raw as List<dynamic>;
    if (arr.length != 0)
      throw Exception('unexpected arr length: expect 0 but see ${arr.length}');
    return StartToReceive();
  }

  @protected
  Stop dco_decode_stop(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    final arr = raw as List<dynamic>;
    if (arr.length != 0)
      throw Exception('unexpected arr length: expect 0 but see ${arr.length}');
    return Stop();
  }

  @protected
  int dco_decode_u_8(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as int;
  }

  @protected
  void dco_decode_unit(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return;
  }

  @protected
  String sse_decode_String(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var inner = sse_decode_list_prim_u_8_strict(deserializer);
    return utf8.decoder.convert(inner);
  }

  @protected
  bool sse_decode_bool(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getUint8() != 0;
  }

  @protected
  DiscoveryIp sse_decode_box_autoadd_discovery_ip(
      SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return (sse_decode_discovery_ip(deserializer));
  }

  @protected
  EventEnum sse_decode_box_autoadd_event_enum(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return (sse_decode_event_enum(deserializer));
  }

  @protected
  FileProgress sse_decode_box_autoadd_file_progress(
      SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return (sse_decode_file_progress(deserializer));
  }

  @protected
  RequestToReceive sse_decode_box_autoadd_request_to_receive(
      SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return (sse_decode_request_to_receive(deserializer));
  }

  @protected
  SendFile sse_decode_box_autoadd_send_file(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return (sse_decode_send_file(deserializer));
  }

  @protected
  Start sse_decode_box_autoadd_start(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return (sse_decode_start(deserializer));
  }

  @protected
  StartToReceive sse_decode_box_autoadd_start_to_receive(
      SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return (sse_decode_start_to_receive(deserializer));
  }

  @protected
  Stop sse_decode_box_autoadd_stop(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return (sse_decode_stop(deserializer));
  }

  @protected
  DiscoveryIp sse_decode_discovery_ip(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var var_addr = sse_decode_String(deserializer);
    var var_hostname = sse_decode_String(deserializer);
    return DiscoveryIp(addr: var_addr, hostname: var_hostname);
  }

  @protected
  Event sse_decode_event(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var var_eventEnum = sse_decode_opt_box_autoadd_event_enum(deserializer);
    return Event(eventEnum: var_eventEnum);
  }

  @protected
  EventEnum sse_decode_event_enum(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs

    var tag_ = sse_decode_i_32(deserializer);
    switch (tag_) {
      case 0:
        var var_field0 = sse_decode_box_autoadd_start(deserializer);
        return EventEnum_Start(var_field0);
      case 1:
        var var_field0 = sse_decode_box_autoadd_stop(deserializer);
        return EventEnum_Stop(var_field0);
      case 2:
        var var_field0 =
            sse_decode_box_autoadd_request_to_receive(deserializer);
        return EventEnum_RequestToReceive(var_field0);
      case 3:
        var var_field0 = sse_decode_box_autoadd_send_file(deserializer);
        return EventEnum_SendFile(var_field0);
      case 4:
        var var_field0 = sse_decode_box_autoadd_start_to_receive(deserializer);
        return EventEnum_StartReceive(var_field0);
      case 5:
        var var_field0 = sse_decode_box_autoadd_discovery_ip(deserializer);
        return EventEnum_DiscoveryIp(var_field0);
      case 6:
        var var_field0 = sse_decode_box_autoadd_file_progress(deserializer);
        return EventEnum_FileProgress(var_field0);
      default:
        throw UnimplementedError('');
    }
  }

  @protected
  double sse_decode_f_64(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getFloat64();
  }

  @protected
  FileProgress sse_decode_file_progress(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var var_fileName = sse_decode_String(deserializer);
    var var_fileProgress = sse_decode_i_32(deserializer);
    var var_isError = sse_decode_bool(deserializer);
    var var_speed = sse_decode_f_64(deserializer);
    var var_progressType = sse_decode_i_32(deserializer);
    return FileProgress(
        fileName: var_fileName,
        fileProgress: var_fileProgress,
        isError: var_isError,
        speed: var_speed,
        progressType: var_progressType);
  }

  @protected
  int sse_decode_i_32(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getInt32();
  }

  @protected
  List<String> sse_decode_list_String(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs

    var len_ = sse_decode_i_32(deserializer);
    var ans_ = <String>[];
    for (var idx_ = 0; idx_ < len_; ++idx_) {
      ans_.add(sse_decode_String(deserializer));
    }
    return ans_;
  }

  @protected
  Uint8List sse_decode_list_prim_u_8_strict(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var len_ = sse_decode_i_32(deserializer);
    return deserializer.buffer.getUint8List(len_);
  }

  @protected
  EventEnum? sse_decode_opt_box_autoadd_event_enum(
      SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs

    if (sse_decode_bool(deserializer)) {
      return (sse_decode_box_autoadd_event_enum(deserializer));
    } else {
      return null;
    }
  }

  @protected
  RequestToReceive sse_decode_request_to_receive(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var var_fileName = sse_decode_String(deserializer);
    var var_from = sse_decode_String(deserializer);
    var var_fileNum = sse_decode_i_32(deserializer);
    return RequestToReceive(
        fileName: var_fileName, from: var_from, fileNum: var_fileNum);
  }

  @protected
  SendFile sse_decode_send_file(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var var_path = sse_decode_list_String(deserializer);
    var var_addr = sse_decode_String(deserializer);
    return SendFile(path: var_path, addr: var_addr);
  }

  @protected
  Start sse_decode_start(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return Start();
  }

  @protected
  StartToReceive sse_decode_start_to_receive(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return StartToReceive();
  }

  @protected
  Stop sse_decode_stop(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return Stop();
  }

  @protected
  int sse_decode_u_8(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getUint8();
  }

  @protected
  void sse_decode_unit(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
  }

  @protected
  void sse_encode_String(String self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_list_prim_u_8_strict(utf8.encoder.convert(self), serializer);
  }

  @protected
  void sse_encode_bool(bool self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putUint8(self ? 1 : 0);
  }

  @protected
  void sse_encode_box_autoadd_discovery_ip(
      DiscoveryIp self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_discovery_ip(self, serializer);
  }

  @protected
  void sse_encode_box_autoadd_event_enum(
      EventEnum self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_event_enum(self, serializer);
  }

  @protected
  void sse_encode_box_autoadd_file_progress(
      FileProgress self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_file_progress(self, serializer);
  }

  @protected
  void sse_encode_box_autoadd_request_to_receive(
      RequestToReceive self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_request_to_receive(self, serializer);
  }

  @protected
  void sse_encode_box_autoadd_send_file(
      SendFile self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_send_file(self, serializer);
  }

  @protected
  void sse_encode_box_autoadd_start(Start self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_start(self, serializer);
  }

  @protected
  void sse_encode_box_autoadd_start_to_receive(
      StartToReceive self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_start_to_receive(self, serializer);
  }

  @protected
  void sse_encode_box_autoadd_stop(Stop self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_stop(self, serializer);
  }

  @protected
  void sse_encode_discovery_ip(DiscoveryIp self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_String(self.addr, serializer);
    sse_encode_String(self.hostname, serializer);
  }

  @protected
  void sse_encode_event(Event self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_opt_box_autoadd_event_enum(self.eventEnum, serializer);
  }

  @protected
  void sse_encode_event_enum(EventEnum self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    switch (self) {
      case EventEnum_Start(field0: final field0):
        sse_encode_i_32(0, serializer);
        sse_encode_box_autoadd_start(field0, serializer);
      case EventEnum_Stop(field0: final field0):
        sse_encode_i_32(1, serializer);
        sse_encode_box_autoadd_stop(field0, serializer);
      case EventEnum_RequestToReceive(field0: final field0):
        sse_encode_i_32(2, serializer);
        sse_encode_box_autoadd_request_to_receive(field0, serializer);
      case EventEnum_SendFile(field0: final field0):
        sse_encode_i_32(3, serializer);
        sse_encode_box_autoadd_send_file(field0, serializer);
      case EventEnum_StartReceive(field0: final field0):
        sse_encode_i_32(4, serializer);
        sse_encode_box_autoadd_start_to_receive(field0, serializer);
      case EventEnum_DiscoveryIp(field0: final field0):
        sse_encode_i_32(5, serializer);
        sse_encode_box_autoadd_discovery_ip(field0, serializer);
      case EventEnum_FileProgress(field0: final field0):
        sse_encode_i_32(6, serializer);
        sse_encode_box_autoadd_file_progress(field0, serializer);
    }
  }

  @protected
  void sse_encode_f_64(double self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putFloat64(self);
  }

  @protected
  void sse_encode_file_progress(FileProgress self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_String(self.fileName, serializer);
    sse_encode_i_32(self.fileProgress, serializer);
    sse_encode_bool(self.isError, serializer);
    sse_encode_f_64(self.speed, serializer);
    sse_encode_i_32(self.progressType, serializer);
  }

  @protected
  void sse_encode_i_32(int self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putInt32(self);
  }

  @protected
  void sse_encode_list_String(List<String> self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_i_32(self.length, serializer);
    for (final item in self) {
      sse_encode_String(item, serializer);
    }
  }

  @protected
  void sse_encode_list_prim_u_8_strict(
      Uint8List self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_i_32(self.length, serializer);
    serializer.buffer.putUint8List(self);
  }

  @protected
  void sse_encode_opt_box_autoadd_event_enum(
      EventEnum? self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs

    sse_encode_bool(self != null, serializer);
    if (self != null) {
      sse_encode_box_autoadd_event_enum(self, serializer);
    }
  }

  @protected
  void sse_encode_request_to_receive(
      RequestToReceive self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_String(self.fileName, serializer);
    sse_encode_String(self.from, serializer);
    sse_encode_i_32(self.fileNum, serializer);
  }

  @protected
  void sse_encode_send_file(SendFile self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_list_String(self.path, serializer);
    sse_encode_String(self.addr, serializer);
  }

  @protected
  void sse_encode_start(Start self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
  }

  @protected
  void sse_encode_start_to_receive(
      StartToReceive self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
  }

  @protected
  void sse_encode_stop(Stop self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
  }

  @protected
  void sse_encode_u_8(int self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putUint8(self);
  }

  @protected
  void sse_encode_unit(void self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
  }
}
