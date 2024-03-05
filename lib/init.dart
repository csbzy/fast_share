import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_share/main.dart';
import 'package:just_share/provider/getit.dart';

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  setupLocator();

  runApp(EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('zh', 'CN')],
      path: 'assets/translations',
      fallbackLocale: const Locale('zh', 'CN'),
      child: const MyApp()));
}

class Init extends StatefulWidget {
  final Widget child;

  const Init({super.key, required this.child});

  @override
  State<Init> createState() => _InitState();
}

class _InitState extends State<Init> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(!isDarkMode(context)
        ? SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.dark,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Theme.of(context).colorScheme.surface)
        : SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: Theme.of(context).colorScheme.surface,
          ));

    return widget.child;
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// 应用初始化
  void init() async {
    /// 通知
  }

  @override
  void initState() {
    super.initState();

    /// App 生命周期
    // AppLifecycleListener(
    //     onResume: () => logger.d('App Resume'),
    //     onInactive: () => logger.d('App Inactive'),
    //     onHide: () => logger.d('App Hide'),
    //     onShow: () => logger.d('App Show'),
    //     onPause: () => logger.d('App Pause'),
    //     onRestart: () => logger.d('App Restart'),
    //     onDetach: () => logger.d('App Detach'),
    //     );

    /// 初始化
    WidgetsBinding.instance.endOfFrame.then((_) {
      if (mounted) init();
    });
  }

  bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
