// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:just_share/src/rust/api/api.dart';
import 'package:just_share/src/rust/api/command.dart';
import 'package:just_share/src/rust/frb_generated.dart';

Future<void> main() async {
  await RustLib.init();
  runApp(const Main());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  var name = "等待";
  var discoverList = <String>[];
  var selectAddr = "";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: navigatorKey,
        home: Scaffold(
          appBar: AppBar(title: const Text('flutter_rust_bridge quickstart')),
          body: Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("现在是:$name 状态"),
              Expanded(
                  child: ListView.builder(
                itemCount: discoverList.length,
                itemBuilder: (context, index) {
                  return Center(
                      child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectAddr = discoverList[index];
                            });
                          },
                          child: ListTile(
                            title: Text(discoverList[index]),
                            selected: selectAddr == discoverList[index],
                          )));
                },
              )),
              ElevatedButton(
                  onPressed: () async {
                    if (selectAddr == "") {
                      print("请选择则接收addr");
                      return;
                    }
                    setState(() {
                      name = "发送状态";
                    });
                    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

                    if (result != null) {
                      List<File> files = result.paths.map((path) => File(path!)).toList();
                      for (File file in files) {
                        print("send $file");
                        String ipAddress = selectAddr.split(':')[0];
                        await sendFile(message: SendFile(path: file.path, addr: "$ipAddress:8965"));
                      }
                    } else {
                      // User canceled the picker
                    }
                  },
                  child: const Text("我要发送")),
              ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      discoverList = [];
                    });
                    await refreshDiscovery();
                  },
                  child: const Text("发现新的ip")),
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
    final s = initCore();
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
                            print("comfirmReceiveFile ${request.fileName}");
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
          discoveryIp: (field0) {
            setState(() {
              discoverList.add(field0.addr);
            });
          },
          sendFile: (_) {},
          startReceive: (_) {});

      print("END RECEIVE event $event");
    });
  }
}
