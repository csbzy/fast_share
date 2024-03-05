// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:just_share/init.dart';
import 'package:just_share/logger/logger.dart';
import 'package:just_share/permission_handler.dart';
import 'package:just_share/provider/getit.dart';
import 'package:just_share/routes/routes.dart';
import 'package:just_share/service/navigation_service.dart';
import 'package:just_share/src/rust/frb_generated.dart';
import 'package:just_share/themes/themes.dart';
import 'package:just_share/views/home.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();
  final res = await requestFilePermission();
  logger.d("$res");

  init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '线下躲猫猫',
        navigatorKey: getIt<NavigationService>().navigatorKey,
        darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
        themeMode: ThemeMode.system,
        localizationsDelegates: [...context.localizationDelegates],
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        initialRoute: '/',
        routes: routes,
        home: const Init(child: HomeScaffold()),
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: lightColorScheme,
          // Use dark or light theme based on system setting.

          // textTheme: TextTheme(
          //   displayLarge: TextStyle(
          //       inherit: true,
          //       fontSize: 112.0.sp,
          //       fontWeight: FontWeight.w100,
          //       textBaseline: TextBaseline.alphabetic),
          //   displayMedium: TextStyle(
          //       debugLabel: 'englishLike displayMedium 2014',
          //       inherit: true,
          //       fontSize: 56.0.sp,
          //       fontWeight: FontWeight.w400,
          //       textBaseline: TextBaseline.alphabetic),
          //   displaySmall: TextStyle(
          //       debugLabel: 'englishLike displaySmall 2014',
          //       inherit: true,
          //       fontSize: 45.0.sp,
          //       fontWeight: FontWeight.w400,
          //       textBaseline: TextBaseline.alphabetic),
          //   headlineLarge: TextStyle(
          //       debugLabel: 'englishLike headlineLarge 2014',
          //       inherit: true,
          //       fontSize: 40.0.sp,
          //       fontWeight: FontWeight.w400,
          //       textBaseline: TextBaseline.alphabetic),
          //   headlineMedium: TextStyle(
          //       debugLabel: 'englishLike headlineMedium 2014',
          //       inherit: true,
          //       fontSize: 34.0.sp,
          //       fontWeight: FontWeight.w400,
          //       textBaseline: TextBaseline.alphabetic),
          //   headlineSmall: TextStyle(
          //       debugLabel: 'englishLike headlineSmall 2014',
          //       inherit: true,
          //       fontSize: 24.0.sp,
          //       fontWeight: FontWeight.w400,
          //       textBaseline: TextBaseline.alphabetic),
          //   titleLarge: TextStyle(
          //       debugLabel: 'englishLike titleLarge 2014',
          //       inherit: true,
          //       fontSize: 20.0.sp,
          //       fontWeight: FontWeight.w500,
          //       textBaseline: TextBaseline.alphabetic),
          //   titleMedium: TextStyle(
          //       debugLabel: 'englishLike titleMedium 2014',
          //       inherit: true,
          //       fontSize: 16.0.sp,
          //       fontWeight: FontWeight.w400,
          //       textBaseline: TextBaseline.alphabetic),
          //   titleSmall: TextStyle(
          //       debugLabel: 'englishLike titleSmall 2014',
          //       inherit: true,
          //       fontSize: 14.0.sp,
          //       fontWeight: FontWeight.w500,
          //       textBaseline: TextBaseline.alphabetic,
          //       letterSpacing: 0.1),
          //   bodyLarge: TextStyle(
          //       debugLabel: 'englishLike bodyLarge 2014',
          //       inherit: true,
          //       fontSize: 14.0.sp,
          //       fontWeight: FontWeight.w500,
          //       textBaseline: TextBaseline.alphabetic),
          //   bodyMedium: TextStyle(
          //       debugLabel: 'englishLike bodyMedium 2014',
          //       inherit: true,
          //       fontSize: 14.0.sp,
          //       fontWeight: FontWeight.w400,
          //       textBaseline: TextBaseline.alphabetic),
          //   bodySmall: TextStyle(
          //       debugLabel: 'englishLike bodySmall 2014',
          //       inherit: true,
          //       fontSize: 10.0.sp,
          //       fontWeight: FontWeight.w400,
          //       textBaseline: TextBaseline.alphabetic),
          //   labelLarge: TextStyle(
          //       debugLabel: 'englishLike labelLarge 2014',
          //       inherit: true,
          //       fontSize: 14.0.sp,
          //       fontWeight: FontWeight.w500,
          //       textBaseline: TextBaseline.alphabetic),
          //   labelMedium: TextStyle(
          //       debugLabel: 'englishLike labelMedium 2014',
          //       inherit: true,
          //       fontSize: 12.0.sp,
          //       fontWeight: FontWeight.w400,
          //       textBaseline: TextBaseline.alphabetic),
          //   labelSmall: TextStyle(
          //       debugLabel: 'englishLike labelSmall 2014',
          //       inherit: true,
          //       fontSize: 10.0.sp,
          //       fontWeight: FontWeight.w400,
          //       textBaseline: TextBaseline.alphabetic,
          //       letterSpacing: 1.5)),
        ),
      );
    });
  }
}

// class _MainState extends State<Main> {
//   var state = "等待";
//   var discoverList = <DiscoveryIp>[];
//   var selectedIndex = -1;
//   Map<String, dynamic> deviceMeta = {};
//   var hostname = "";
//   Map<String, FileProgress> uploadFileList = {};

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         navigatorKey: navigatorKey,
//         home: ResponsiveBuilder(builder: (sizingInformation) {
//           if (sizingInformation.isMobile) {
//             return const HomeScaffold();
//           } else {
//             return const HomeScaffold();
//           }
//         }));
    // Scaffold(
    //   appBar: AppBar(title: const Text('flutter_rust_bridge quickstart')),
    //   body: Center(
    //       child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       Text("主机名 $hostname 现在是:$state 状态"),
    //       Expanded(
    //           child: ListView.builder(
    //         itemCount: discoverList.length,
    //         itemBuilder: (context, index) {
    //           return Center(
    //               child: GestureDetector(
    //                   onTap: () {
    //                     setState(() {
    //                       selectedIndex = index;
    //                     });
    //                   },
    //                   child: ListTile(
    //                     title: Text(discoverList[index].hostname),
    //                     selected: selectedIndex == index,
    //                   )));
    //         },
    //       )),
    //       Expanded(
    //           child: Container(
    //               decoration: BoxDecoration(
    //                   border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(20)),
    //               child: ListView.builder(
    //                 itemCount: uploadFileList.length,
    //                 itemBuilder: (context, index) {
    //                   final fileName = uploadFileList.keys.elementAt(index);
    //                   final progress = uploadFileList[fileName]!.fileProgress;
    //                   final speed = uploadFileList[fileName]!.speed;

    //                   return Center(
    //                       child: ListTile(
    //                           title: Text(fileName),
    //                           subtitle: Row(children: [
    //                             Expanded(
    //                                 child: LinearProgressIndicator(
    //                               minHeight: 10.0,
    //                               value: progress / 100,
    //                             )),
    //                             const SizedBox(
    //                               width: 10,
    //                             ),
    //                             Text("${speed.toStringAsFixed(3)} MB/s")
    //                           ])));
    //                 },
    //               ))),
    //       ElevatedButton(
    //           onPressed: () async {
    //             if (selectedIndex == -1) {
    //               logger.d("请选择接收addr");
    //               return;
    //             }
    //             setState(() {
    //               state = "发送状态";
    //             });
    //             FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

    //             if (result != null) {
    //               List<File> files = result.paths.map((path) => File(path!)).toList();
    //               final filePaths = files.map((file) => file.path).toList();
    //               String ipAddress = discoverList[selectedIndex].addr.split(':')[0];
    //               await sendFile(message: SendFile(path: filePaths, addr: "$ipAddress:8965"));
    //             } else {
    //               // User canceled the picker
    //             }
    //           },
    //           child: const Text("我要发送")),
    //       ElevatedButton(
    //           onPressed: () async {
    //             setState(() {
    //               discoverList = [];
    //             });
    //             await refreshDiscovery();
    //           },
    //           child: const Text("发现新的ip")),
    //     ],
    //   )),
    // )
    // );
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   initApp();
  // }
// }
