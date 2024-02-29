// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:just_share/permission_handler.dart';
import 'package:just_share/src/rust/api/api.dart';
import 'package:just_share/src/rust/api/command.dart';
import 'package:just_share/src/rust/frb_generated.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();
  final res = await requestFilePermission();
  print("$res");

  runApp(const Main());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  var state = "等待";
  var discoverList = <DiscoveryIp>[];
  var selectedIndex = -1;
  Map<String, dynamic> deviceMeta = {};
  var hostname = "";
  Map<String, FileProgress> uploadFileList = {};

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
              Text("主机名 $hostname 现在是:$state 状态"),
              Expanded(
                  child: ListView.builder(
                itemCount: discoverList.length,
                itemBuilder: (context, index) {
                  return Center(
                      child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          child: ListTile(
                            title: Text(discoverList[index].hostname),
                            selected: selectedIndex == index,
                          )));
                },
              )),
              Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(20)),
                      child: ListView.builder(
                        itemCount: uploadFileList.length,
                        itemBuilder: (context, index) {
                          final fileName = uploadFileList.keys.elementAt(index);
                          final progress = uploadFileList[fileName]!.fileProgress;
                          final speed = uploadFileList[fileName]!.speed;

                          return Center(
                              child: ListTile(
                                  title: Text(fileName),
                                  subtitle: Row(children: [
                                    Expanded(
                                        child: LinearProgressIndicator(
                                      minHeight: 10.0,
                                      value: progress / 100,
                                    )),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text("${speed.toStringAsFixed(3)} MB/s")
                                  ])));
                        },
                      ))),
              ElevatedButton(
                  onPressed: () async {
                    if (selectedIndex == -1) {
                      print("请选择接收addr");
                      return;
                    }
                    setState(() {
                      state = "发送状态";
                    });
                    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

                    if (result != null) {
                      List<File> files = result.paths.map((path) => File(path!)).toList();
                      final filePaths = files.map((file) => file.path).toList();
                      String ipAddress = discoverList[selectedIndex].addr.split(':')[0];
                      await sendFile(message: SendFile(path: filePaths, addr: "$ipAddress:8965"));
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

  Future<String> getDeviceName() async {
    Map deviceInfo = (await DeviceInfoPlugin().deviceInfo).data;
    String? brand = deviceInfo['brand'];
    String? model = deviceInfo['model'];
    String? name = deviceInfo['name'];

    return name ?? '$brand $model';
  }

  Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        // // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // // ignore: avoid_slow_async_io
        // if (!await directory.exists()) directory = await getExternalStorageDirectory();
        // directory = await getApplicationDocumentsDirectory();
      } else {
        directory = await getDownloadsDirectory();
      }
    } catch (err, stack) {
      print("Cannot get download folder path");
    }
    print("download path ${directory?.path}");
    return directory?.path;
  }

  handleEvent(Event event) {
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
                content: Text("${request.from}要发送${request.fileName}等${request.fileNum}文件給您"),
                actions: [
                  TextButton(
                      onPressed: () async {
                        print("comfirmReceiveFile ${request.fileName}");
                        await requestFilePermission();
                        await comfirmReceiveFile(file: request.fileName, accept: true);

                        Navigator.pop(context);
                      },
                      child: const Text("接收")),
                  TextButton(
                      onPressed: () async {
                        await comfirmReceiveFile(file: request.fileName, accept: false);
                        Navigator.pop(context);
                      },
                      child: const Text("取消")),
                ],
              );
            });
      },
      discoveryIp: (field0) {
        setState(() {
          discoverList.add(field0);
        });
      },
      sendFile: (_) {},
      startReceive: (_) {},
      fileProgress: (FileProgress field0) {
        setState(() {
          print("receive file progress ${field0.fileName} ${field0.fileProgress}");
          uploadFileList[field0.fileName] = field0;
        });
      },
    );

    print("END RECEIVE event $event");
  }

  initApp() async {
    String devicename = "";
    if (Platform.isAndroid || Platform.isIOS) {
      devicename = await getDeviceName();
      print(devicename);
      hostname = devicename;
      setState(() {
        hostname = devicename;
      });
    } else {
      setState(() {
        hostname = Platform.localHostname;
      });
      devicename = Platform.localHostname;
    }

    print("get devicname $devicename");
    final downloadsDir = await getDownloadPath();
    final s = initCore(hostname: devicename, directory: downloadsDir!);
    s.listen(handleEvent);
  }

  @override
  void initState() {
    super.initState();
    initApp();
  }
}
