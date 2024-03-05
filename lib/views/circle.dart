import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_share/logger/logger.dart';

class WaterRipples extends StatefulWidget {
  final double scale;
  final double initRaidus;
  const WaterRipples({
    Key? key,
    required this.scale,
    required this.initRaidus,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _WaterRipplesState();
}

class _WaterRipplesState extends State<WaterRipples> with TickerProviderStateMixin, WidgetsBindingObserver {
  //动画控制器
  final List<AnimationController> _controllers = [];
  //动画控件集合
  final List<Widget> _children = [];
  //添加蓝牙检索动画计时器
  Timer? _searchBluetoothTimer;
  late double _raidus = widget.initRaidus;

  @override
  Widget build(BuildContext context) {
    logger.d(" initraidus ${widget.initRaidus} $_raidus");
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: _raidus,
        height: _raidus,
        child: Stack(
          alignment: Alignment.center,
          children: _children,
        ),
      ),
    );
  }

  ///监听应用状态，
  /// 生命周期变化时回调
  /// resumed:应用可见并可响应用户操作
  /// inactive:用户可见，但不可响应用户操作
  /// paused:已经暂停了，用户不可见、不可操作
  /// suspending：应用被挂起，此状态IOS永远不会回调
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      //应用退至后台，
      _disposeSearchAnimation();
    } else if (state == AppLifecycleState.resumed) {
      //应用回到前台，重新启动动画
      _startAnimation();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _disposeSearchAnimation();
    updateRadius();
    _startAnimation();
  }

  @override
  void dispose() {
    logger.d("tag--=========================dispose===================");
    //销毁动画
    _disposeSearchAnimation();
    //销毁应用生命周期观察者
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    logger.d("init");
    _startAnimation();
    //添加应用生命周期监听
    WidgetsBinding.instance.addObserver(this);
  }

  void updateRadius() {
    // 获取屏幕宽度
    logger.d("update radius $_raidus ");

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    // 根据屏幕宽度设置宽高
    _raidus = (screenWidth > screenHeight ? screenHeight : screenWidth); //* widget.scale / 2;
    logger.d("update radius $_raidus  $screenWidth $screenHeight");
  }

  ///添加蓝牙检索动画控件
  ///init: 首次添加5个基本控件时，=true，
  void _addSearchAnimation(int index, bool init) {
    var controller = _createController(index);
    var startRadius = widget.initRaidus * 0.2;
    var endRadius = widget.initRaidus;
    logger.d("startRadius $startRadius endRadius $endRadius");
    _controllers.add(controller);
    if (!init) {
      _children.removeAt(0);
    }
    var animation =
        Tween(begin: startRadius, end: endRadius).animate(CurvedAnimation(parent: controller, curve: Curves.linear));
    _children.add(AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget? child) {
          return Opacity(
            opacity: 1 - (animation.value - startRadius) / endRadius,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xff9fbaff).withOpacity(1 - index * 0.1),
              ),
              width: animation.value,
              height: animation.value,
            ),
          );
        }));
    controller.forward();
    setState(() {});
    // }
  }

  ///创建蓝牙检索动画控制器
  AnimationController _createController(int count) {
    var controller = AnimationController(duration: const Duration(milliseconds: 9000), vsync: this);
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          controller.dispose();
          if (_controllers.contains(controller)) {
            _controllers.remove(controller);
          }
          //每次动画控件结束时，添加新的控件，保持动画的持续性
          if (mounted) _addSearchAnimation(count, false);
        });
      }
    });
    return controller;
  }

  ///销毁动画
  void _disposeSearchAnimation() {
    //释放动画所有controller
    for (var element in _controllers) {
      element.dispose();
    }
    _controllers.clear();
    _searchBluetoothTimer?.cancel();
    _children.clear();
  }

  ///初始化蓝牙检索动画，依次添加5个缩放动画，形成水波纹动画效果
  void _startAnimation() {
    //动画启动前确保_children控件总数为0
    _children.clear();
    int count = 0;
    _addSearchAnimation(count, true);
    //动画启动前确保_children控件总数为0
    _children.clear();
    //以后每隔1秒，再次添加一个缩放动画，总共添加4个
    _searchBluetoothTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      _addSearchAnimation(count, true);
      count++;
      if (count >= 10) {
        timer.cancel();
      }
    });
  }
}
