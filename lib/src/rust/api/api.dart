// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.28.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'command.dart';
import 'command/event.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

/// frb_marker: #[frb(init)]
Future<void> initApp({dynamic hint}) =>
    RustLib.instance.api.initApp(hint: hint);

Future<void> stop({dynamic hint}) => RustLib.instance.api.stop(hint: hint);

Future<void> sendFile({required SendFile message, dynamic hint}) =>
    RustLib.instance.api.sendFile(message: message, hint: hint);

Future<void> comfirmReceiveFile(
        {required bool accept, required String file, dynamic hint}) =>
    RustLib.instance.api
        .comfirmReceiveFile(accept: accept, file: file, hint: hint);

Future<void> refreshDiscovery({dynamic hint}) =>
    RustLib.instance.api.refreshDiscovery(hint: hint);

Stream<Event> initCore(
        {required String hostname, required String directory, dynamic hint}) =>
    RustLib.instance.api
        .initCore(hostname: hostname, directory: directory, hint: hint);
