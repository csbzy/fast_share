// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.24.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../frb_generated.dart';
import '../command.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:freezed_annotation/freezed_annotation.dart' hide protected;
part 'event.freezed.dart';

@freezed
sealed class EventEnum with _$EventEnum {
  const factory EventEnum.start(
    Start field0,
  ) = EventEnum_Start;
  const factory EventEnum.stop(
    Stop field0,
  ) = EventEnum_Stop;
  const factory EventEnum.requestToReceive(
    RequestToReceive field0,
  ) = EventEnum_RequestToReceive;
  const factory EventEnum.sendFile(
    SendFile field0,
  ) = EventEnum_SendFile;
  const factory EventEnum.startReceive(
    StartToReceive field0,
  ) = EventEnum_StartReceive;
}