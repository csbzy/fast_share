// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.24.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'command.dart';
import 'command/event.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

Future<void> start({dynamic hint}) => RustLib.instance.api.start(hint: hint);

Future<void> stop({dynamic hint}) => RustLib.instance.api.stop(hint: hint);

Future<void> sendFile({required SendFile message, dynamic hint}) =>
    RustLib.instance.api.sendFile(message: message, hint: hint);

Future<void> receiveFile({dynamic hint}) =>
    RustLib.instance.api.receiveFile(hint: hint);

Future<void> comfirmReceiveFile({required String name, dynamic hint}) =>
    RustLib.instance.api.comfirmReceiveFile(name: name, hint: hint);

Stream<Event> handleStream({dynamic hint}) =>
    RustLib.instance.api.handleStream(hint: hint);