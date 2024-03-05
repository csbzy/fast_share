import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:just_share/logger/logger.dart';
import 'package:just_share/model/homeVideModel.dart';
import 'package:just_share/provider/base_view.dart';
import 'package:just_share/src/rust/api/api.dart';
import 'package:just_share/src/rust/api/command.dart';
import 'package:just_share/widget/responsive_builder.dart';
import 'package:sizer/sizer.dart';

class HomeScaffold extends StatelessWidget {
  static String routeName = '/home';

  const HomeScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (SizingInformation sizingInformation) {
      logger
          .d("build:${sizingInformation.screenWidth} ${sizingInformation.screenHeight} ${sizingInformation.isMobile}");
      return BaseView<HomeScaffoldViewModel>(
        onModelReady: (model) async {
          logger.d("model init");
          await model.init();
        },
        didChangeDependencies: (model) {
          logger.d("did change de");
          model.didChangeDependencies();
        },
        builder: (context, model, child) {
          var discoveryCircleSize = 80.w > 80.h ? 50.h : 50.w;
          // discoveryCircleSize = sizingInformation.isTabletOrDesktop ? discoveryCircleSize / 2 : discoveryCircleSize;
          return Scaffold(
              appBar: AppBar(
                // title: const Text('Home'),
                actions: [IconButton.filled(onPressed: () {}, icon: const Icon(Icons.menu))],
              ),
              body: Align(
                  alignment: const Alignment(0.0, 0.0),
                  child: Container(
                      decoration: const BoxDecoration(color: Color(0xffF8F8F8)),
                      child: Column(children: [
                        sizingInformation.isTabletOrDesktop
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    model.discoveryClient(discoveryCircleSize),
                                    model.recentlyFileList(discoveryCircleSize)
                                  ])
                            : Column(children: [
                                model.discoveryClient(discoveryCircleSize),
                                const SizedBox(height: 10),
                                model.recentlyFileList(discoveryCircleSize * 1.8),
                              ]),
                        const Spacer(),
                        ElevatedButton.icon(
                            onPressed: () async {
                              if (model.selectedIndex.isEmpty) {
                                logger.d("请选择接收addr");
                                return;
                              }

                              FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

                              if (result != null) {
                                List<File> files = result.paths.map((path) => File(path!)).toList();
                                final filePaths = files.map((file) => file.path).toList();
                                String ipAddress = model.discoverList[model.selectedIndex]!.addr.split(':')[0];
                                await sendFile(message: SendFile(path: filePaths, addr: "$ipAddress:8965"));
                              } else {
                                // User canceled the picker
                              }
                            },
                            icon: const Icon(Icons.send_and_archive_rounded),
                            label: Text("send".tr())),
                        const Spacer(),
                      ]))));
        },
      );
    });
  }
}
