import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:just_share/src/rust/api/command.dart';
import 'package:just_share/src/rust/api/core/core.dart';
import 'package:just_share/src/rust/api/simple.dart';
import 'package:just_share/src/rust/frb_generated.dart';

Future<void> main() async {
  await RustLib.init();
  await initCore();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(title: const Text('flutter_rust_bridge quickstart')),
      body: Center(
          child: Column(
        children: [
          Text("Hello, ${greet(name: "adf")}!"),
          ElevatedButton(
              onPressed: () async {
                print(("START TO RECEIVE"));
                await receiveFile();
              },
              child: const Text("我要接收")),
          ElevatedButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

                if (result != null) {
                  List<File> files = result.paths.map((path) => File(path!)).toList();
                  for (File file in files) {
                    print("send $file");
                    await sendFile(message: SendFile(path: file.path, addr: "localhost:8965"));
                  }
                } else {
                  // User canceled the picker
                }
              },
              child: const Text("我要发送"))
        ],
      )),
    ));
  }
}
