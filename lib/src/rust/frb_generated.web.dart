// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.24.

// ignore_for_file: unused_import, unused_element, unnecessary_import, duplicate_ignore, invalid_use_of_internal_member, annotate_overrides, non_constant_identifier_names, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables, unused_field

import 'api/api.dart';
import 'api/command.dart';
import 'api/core/core.dart';
import 'dart:async';
import 'dart:convert';
import 'frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated_web.dart';

abstract class RustLibApiImplPlatform extends BaseApiImpl<RustLibWire> {
  RustLibApiImplPlatform({
    required super.handler,
    required super.wire,
    required super.generalizedFrbRustBinding,
    required super.portManager,
  });

  CrossPlatformFinalizerArg
      get rust_arc_decrement_strong_count_ArcMutexOptionTokioNetTcpListenerPtr =>
          wire.rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexOptiontokionetTcpListener;

  CrossPlatformFinalizerArg
      get rust_arc_decrement_strong_count_ArcMutexReceiverStringPtr => wire
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexReceiverString;

  CrossPlatformFinalizerArg
      get rust_arc_decrement_strong_count_ArcMutexSenderStringPtr => wire
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexSenderString;

  CrossPlatformFinalizerArg
      get rust_arc_decrement_strong_count_StdSyncArcMutexOptionJustShareCorePtr =>
          wire.rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockstdsyncArcMutexOptionJustShareCore;

  @protected
  ArcMutexOptionTokioNetTcpListener
      dco_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexOptiontokionetTcpListener(
          dynamic raw);

  @protected
  ArcMutexReceiverString
      dco_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexReceiverString(
          dynamic raw);

  @protected
  ArcMutexSenderString
      dco_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexSenderString(
          dynamic raw);

  @protected
  StdSyncArcMutexOptionJustShareCore
      dco_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockstdsyncArcMutexOptionJustShareCore(
          dynamic raw);

  @protected
  ArcMutexOptionTokioNetTcpListener
      dco_decode_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexOptiontokionetTcpListener(
          dynamic raw);

  @protected
  ArcMutexReceiverString
      dco_decode_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexReceiverString(
          dynamic raw);

  @protected
  ArcMutexSenderString
      dco_decode_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexSenderString(
          dynamic raw);

  @protected
  StdSyncArcMutexOptionJustShareCore
      dco_decode_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockstdsyncArcMutexOptionJustShareCore(
          dynamic raw);

  @protected
  String dco_decode_String(dynamic raw);

  @protected
  JustShareCoreConfig dco_decode_box_autoadd_just_share_core_config(
      dynamic raw);

  @protected
  MutexJustShareCore dco_decode_box_autoadd_mutex_just_share_core(dynamic raw);

  @protected
  SendFile dco_decode_box_autoadd_send_file(dynamic raw);

  @protected
  JustShareCore dco_decode_just_share_core(dynamic raw);

  @protected
  JustShareCoreConfig dco_decode_just_share_core_config(dynamic raw);

  @protected
  Uint8List dco_decode_list_prim_u_8_strict(dynamic raw);

  @protected
  MutexJustShareCore dco_decode_mutex_just_share_core(dynamic raw);

  @protected
  SendFile dco_decode_send_file(dynamic raw);

  @protected
  int dco_decode_u_16(dynamic raw);

  @protected
  int dco_decode_u_8(dynamic raw);

  @protected
  void dco_decode_unit(dynamic raw);

  @protected
  int dco_decode_usize(dynamic raw);

  @protected
  ArcMutexOptionTokioNetTcpListener
      sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexOptiontokionetTcpListener(
          SseDeserializer deserializer);

  @protected
  ArcMutexReceiverString
      sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexReceiverString(
          SseDeserializer deserializer);

  @protected
  ArcMutexSenderString
      sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexSenderString(
          SseDeserializer deserializer);

  @protected
  StdSyncArcMutexOptionJustShareCore
      sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockstdsyncArcMutexOptionJustShareCore(
          SseDeserializer deserializer);

  @protected
  ArcMutexOptionTokioNetTcpListener
      sse_decode_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexOptiontokionetTcpListener(
          SseDeserializer deserializer);

  @protected
  ArcMutexReceiverString
      sse_decode_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexReceiverString(
          SseDeserializer deserializer);

  @protected
  ArcMutexSenderString
      sse_decode_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexSenderString(
          SseDeserializer deserializer);

  @protected
  StdSyncArcMutexOptionJustShareCore
      sse_decode_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockstdsyncArcMutexOptionJustShareCore(
          SseDeserializer deserializer);

  @protected
  String sse_decode_String(SseDeserializer deserializer);

  @protected
  JustShareCoreConfig sse_decode_box_autoadd_just_share_core_config(
      SseDeserializer deserializer);

  @protected
  MutexJustShareCore sse_decode_box_autoadd_mutex_just_share_core(
      SseDeserializer deserializer);

  @protected
  SendFile sse_decode_box_autoadd_send_file(SseDeserializer deserializer);

  @protected
  JustShareCore sse_decode_just_share_core(SseDeserializer deserializer);

  @protected
  JustShareCoreConfig sse_decode_just_share_core_config(
      SseDeserializer deserializer);

  @protected
  Uint8List sse_decode_list_prim_u_8_strict(SseDeserializer deserializer);

  @protected
  MutexJustShareCore sse_decode_mutex_just_share_core(
      SseDeserializer deserializer);

  @protected
  SendFile sse_decode_send_file(SseDeserializer deserializer);

  @protected
  int sse_decode_u_16(SseDeserializer deserializer);

  @protected
  int sse_decode_u_8(SseDeserializer deserializer);

  @protected
  void sse_decode_unit(SseDeserializer deserializer);

  @protected
  int sse_decode_usize(SseDeserializer deserializer);

  @protected
  int sse_decode_i_32(SseDeserializer deserializer);

  @protected
  bool sse_decode_bool(SseDeserializer deserializer);

  @protected
  void
      sse_encode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexOptiontokionetTcpListener(
          ArcMutexOptionTokioNetTcpListener self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexReceiverString(
          ArcMutexReceiverString self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexSenderString(
          ArcMutexSenderString self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockstdsyncArcMutexOptionJustShareCore(
          StdSyncArcMutexOptionJustShareCore self, SseSerializer serializer);

  @protected
  void
      sse_encode_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexOptiontokionetTcpListener(
          ArcMutexOptionTokioNetTcpListener self, SseSerializer serializer);

  @protected
  void
      sse_encode_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexReceiverString(
          ArcMutexReceiverString self, SseSerializer serializer);

  @protected
  void
      sse_encode_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexSenderString(
          ArcMutexSenderString self, SseSerializer serializer);

  @protected
  void
      sse_encode_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockstdsyncArcMutexOptionJustShareCore(
          StdSyncArcMutexOptionJustShareCore self, SseSerializer serializer);

  @protected
  void sse_encode_String(String self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_just_share_core_config(
      JustShareCoreConfig self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_mutex_just_share_core(
      MutexJustShareCore self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_send_file(
      SendFile self, SseSerializer serializer);

  @protected
  void sse_encode_just_share_core(JustShareCore self, SseSerializer serializer);

  @protected
  void sse_encode_just_share_core_config(
      JustShareCoreConfig self, SseSerializer serializer);

  @protected
  void sse_encode_list_prim_u_8_strict(
      Uint8List self, SseSerializer serializer);

  @protected
  void sse_encode_mutex_just_share_core(
      MutexJustShareCore self, SseSerializer serializer);

  @protected
  void sse_encode_send_file(SendFile self, SseSerializer serializer);

  @protected
  void sse_encode_u_16(int self, SseSerializer serializer);

  @protected
  void sse_encode_u_8(int self, SseSerializer serializer);

  @protected
  void sse_encode_unit(void self, SseSerializer serializer);

  @protected
  void sse_encode_usize(int self, SseSerializer serializer);

  @protected
  void sse_encode_i_32(int self, SseSerializer serializer);

  @protected
  void sse_encode_bool(bool self, SseSerializer serializer);
}

// Section: wire_class

class RustLibWire implements BaseWire {
  RustLibWire.fromExternalLibrary(ExternalLibrary lib);

  void rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexOptiontokionetTcpListener(
          dynamic ptr) =>
      wasmModule
          .rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexOptiontokionetTcpListener(
              ptr);

  void rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexOptiontokionetTcpListener(
          dynamic ptr) =>
      wasmModule
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexOptiontokionetTcpListener(
              ptr);

  void rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexReceiverString(
          dynamic ptr) =>
      wasmModule
          .rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexReceiverString(
              ptr);

  void rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexReceiverString(
          dynamic ptr) =>
      wasmModule
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexReceiverString(
              ptr);

  void rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexSenderString(
          dynamic ptr) =>
      wasmModule
          .rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexSenderString(
              ptr);

  void rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexSenderString(
          dynamic ptr) =>
      wasmModule
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexSenderString(
              ptr);

  void rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockstdsyncArcMutexOptionJustShareCore(
          dynamic ptr) =>
      wasmModule
          .rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockstdsyncArcMutexOptionJustShareCore(
              ptr);

  void rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockstdsyncArcMutexOptionJustShareCore(
          dynamic ptr) =>
      wasmModule
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockstdsyncArcMutexOptionJustShareCore(
              ptr);
}

@JS('wasm_bindgen')
external RustLibWasmModule get wasmModule;

@JS()
@anonymous
class RustLibWasmModule implements WasmModule {
  @override
  external Object /* Promise */ call([String? moduleName]);

  @override
  external RustLibWasmModule bind(dynamic thisArg, String moduleName);

  external void
      rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexOptiontokionetTcpListener(
          dynamic ptr);

  external void
      rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexOptiontokionetTcpListener(
          dynamic ptr);

  external void
      rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexReceiverString(
          dynamic ptr);

  external void
      rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexReceiverString(
          dynamic ptr);

  external void
      rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexSenderString(
          dynamic ptr);

  external void
      rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockArcMutexSenderString(
          dynamic ptr);

  external void
      rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockstdsyncArcMutexOptionJustShareCore(
          dynamic ptr);

  external void
      rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockstdsyncArcMutexOptionJustShareCore(
          dynamic ptr);
}
