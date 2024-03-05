// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_share/logger/logger.dart';
import 'package:just_share/permission_handler.dart';
import 'package:just_share/provider/base_model.dart';
import 'package:just_share/provider/getit.dart';
import 'package:just_share/service/navigation_service.dart';
import 'package:just_share/src/rust/api/api.dart';
import 'package:just_share/src/rust/api/command.dart';
import 'package:just_share/views/avatar.dart';
import 'package:just_share/views/radar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';

class DiscoveryIPWithAlignment extends DiscoveryIp {
  Alignment? _alignment;
  DiscoveryIPWithAlignment({required super.addr, required super.hostname});

  Alignment get alignment {
    return _alignment ?? generateRandomAlignment();
  }

  Alignment generateRandomAlignment() {
    final random = Random();
    double rangeMin = -0.5;
    double rangeMax = 0.5;
    double alignX = rangeMin + (rangeMax - rangeMin) * random.nextDouble();
    double alignY = rangeMin + (rangeMax - rangeMin) * random.nextDouble();
    _alignment = Alignment(alignX, alignY);
    return _alignment!;
  }

  void setAlignment(Alignment alignment) {
    _alignment = alignment;
  }
}

class HomeScaffoldViewModel extends BaseModel {
  // var state = "等待";
  // var discoverList = <DiscoveryIp>[];
  var selectedIndex = "";
  Map<String, DiscoveryIPWithAlignment> discoverList = {};
  var hostname = "";
  Map<String, FileProgress> uploadFileList = {};
  var width = 0.0;

  didChangeDependencies() {
    logger.d("before didChangeDependencies width $width");

    width = 10.w;
    logger.d("didChangeDependencies width $width ${SizerUtil.width}");
    notifyListeners();
  }

  Widget discoveryClient(double size) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("discovery_title".tr()),
      Center(
          child: SizedBox(
              width: size,
              height: size,
              child: Stack(
                children: [
                  Center(
                    child: SvgPicture.asset(
                      "assets/images/Bussola.svg",
                    ),
                  ),
                  const Positioned.fill(
                    child: RadarScan(),
                  ),
                  ...generateDiscoveryList(),
                ],
              ))),
      Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("discovery_toggle_title".tr()),
          TextButton(
              onPressed: () async {
                logger.d("refresh discovery");
                await refreshDiscovery();
              },
              child: Text("yes".tr()))
        ],
      ))
    ]);
  }

  List<Align> generateDiscoveryList() {
    final size = 3.w > 3.h ? 3.w : 3.h;
    return discoverList.entries
        .map((e) => Align(
            alignment: e.value.alignment,
            child: Container(
              decoration: BoxDecoration(
                color: selectedIndex == e.value.addr ? Colors.green : Colors.grey,
                border: selectedIndex == e.value.addr ? Border.all(color: Colors.green, width: 2.0) : null,
                borderRadius: BorderRadius.circular(50),
              ),
              child: BreathingCircleAvatar(
                  circleAvatarScale: 1 / 30,
                  avatarCircleSize: size,
                  discoveryIp: e.value,
                  selectedHandler: (DiscoveryIp ip) {
                    logger.d("selected ${ip.addr == selectedIndex} selectindex $selectedIndex");
                    if (selectedIndex == ip.addr) {
                      selectedIndex == "";
                      notifyListeners();
                    } else {
                      selectedIndex = ip.addr;
                    }
                    notifyListeners();

                    logger.d("selected ${ip.addr} selectindex $selectedIndex");
                  }),
            )))
        .toList();
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
    } catch (err) {
      logger.d("Cannot get download folder path");
    }
    logger.d("download path ${directory?.path}");
    return directory?.path;
  }

  handleEvent(Event event) {
    logger.d("event ${event.eventEnum!.field0}");
    event.eventEnum?.when(
      start: (_) {},
      stop: (_) {},
      requestToReceive: (request) {
        logger.d("enter request to receive");
        showDialog(
            context: getIt<NavigationService>().navigatorKey.currentContext!,
            builder: (context) {
              return AlertDialog(
                content: Text("${request.from}要发送${request.fileName}等${request.fileNum}文件給您"),
                actions: [
                  TextButton(
                    onPressed: () async {
                      logger.d("comfirmReceiveFile ${request.fileName}");
                      await requestFilePermission();
                      await comfirmReceiveFile(file: request.fileName, accept: true);

                      Navigator.pop(context);
                    },
                    child: const Text("接收"),
                  ),
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
        var dip = discoverList[field0.addr];
        var newDip = DiscoveryIPWithAlignment(addr: field0.addr, hostname: field0.hostname);
        if (dip != null) {
          newDip.setAlignment(dip.alignment);
        }
        discoverList[field0.addr] = newDip;
        logger.d("${newDip.alignment}  ${dip?.alignment}");
        notifyListeners();
      },
      sendFile: (_) {},
      startReceive: (_) {},
      fileProgress: (FileProgress field0) {
        logger.d("receive file progress ${field0.fileName} ${field0.fileProgress}");
        uploadFileList[field0.fileName] = field0;
        notifyListeners();
      },
    );

    logger.d("END RECEIVE event $event");
  }

  init() async {
    String devicename = "";
    if (Platform.isAndroid || Platform.isIOS) {
      devicename = await getDeviceName();
      logger.d("devicename");
      hostname = devicename;
      hostname = devicename;
    } else {
      hostname = Platform.localHostname;
      devicename = Platform.localHostname;
    }

    logger.d("get devicname $devicename");
    final downloadsDir = await getDownloadPath();
    final s = initCore(hostname: devicename, directory: downloadsDir!);
    s.listen(handleEvent);
  }

  Widget recentlyFileList(double size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("recently_list_title".tr()),
        Center(
            child: Container(
                width: size,
                height: size,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.black)),
                child: ListView.builder(
                  itemCount: uploadFileList.length,
                  itemBuilder: (context, index) {
                    final fileName = uploadFileList.keys.elementAt(index);
                    final progress = uploadFileList[fileName]!.fileProgress;
                    final speed = uploadFileList[fileName]!.speed;

                    return ListTile(
                        onTap: () {},
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
                        ]));
                  },
                ))),
        // const Spacer(),
      ],
    );
  }
}
