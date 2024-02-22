import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:just_share/src/rust/api/api.dart';
import 'package:just_share/src/rust/api/command.dart';
import 'package:just_share/src/rust/frb_generated.dart';

Future<void> main() async {
  await RustLib.init();
  await initCore();
  runApp(const Main());
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  var name = "adf";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(title: const Text('flutter_rust_bridge quickstart')),
      body: Center(
          child: Column(
        children: [
          Text("Hello, $name !"),
          ElevatedButton(
              onPressed: () async {
                print(("incore"));
                // await initCore();
                final s = handleStream();
                s.listen((event) {
                  print("event $event");
                  setState(() {
                    name = event;
                  });
                });
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

  @override
  void initState() {
    super.initState();
  }
}
