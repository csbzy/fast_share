import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:just_share/src/rust/api/api.dart';
import 'package:just_share/src/rust/api/command.dart';
import 'package:just_share/src/rust/frb_generated.dart';

Future<void> main() async {
  await RustLib.init();
  await start();
  runApp(const Main());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
        navigatorKey: navigatorKey,
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
    receiveEvent();
  }

  receiveEvent() {
    final s = handleStream();
    s.listen((event) {
      print("event ${event.eventEnum!.field0}");
      event.eventEnum?.when(
          start: (_) {},
          stop: (_) {},
          requestToReceive: (request) {
            print("enter request to receive");
            showDialog(
                context: navigatorKey.currentState!.overlay!.context,
                builder: (context) {
                  return AlertDialog(
                    content: Text("${request.from}要发送文件到你,文件名称${request.fileName}"),
                    actions: [
                      TextButton(
                          onPressed: () async {
                            await comfirmReceiveFile(name: request.fileName);
                            Navigator.pop(context);
                          },
                          child: const Text("接收")),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("取消")),
                    ],
                  );
                });
          },
          sendFile: (_) {},
          startReceive: (_) {});

      print("END RECEIVE event $event");
    });
  }
}
