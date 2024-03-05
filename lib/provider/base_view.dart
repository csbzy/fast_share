import 'package:flutter/material.dart';
import 'package:just_share/logger/logger.dart';
import 'package:provider/provider.dart';

import 'base_model.dart';
import 'getit.dart';

class BaseView<T extends BaseModel> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget? child) builder;
  final Function(T)? onModelReady;
  final Function(T)? onModelDisposed;
  final Function(T, AppLifecycleState state)? onChangeAppLifecycleState;
  final Widget? child;
  final bool? widgetChangeNotifiter;
  final Function(T, Widget oldWidget)? didUpdateWidget;
  final Function(T)? didChangeDependencies;

  final bool wantKeepAlive;

  const BaseView(
      {Key? key,
      required this.builder,
      this.onModelReady,
      this.child,
      this.onModelDisposed,
      this.onChangeAppLifecycleState,
      this.widgetChangeNotifiter,
      this.didUpdateWidget,
      this.didChangeDependencies,
      this.wantKeepAlive = false})
      : super(key: key);

  @override
  BaseViewState<T> createState() => BaseViewState<T>();
}

class BaseViewState<T extends BaseModel> extends State<BaseView<T>>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  T model = getIt<T>();

  @override
  bool get wantKeepAlive => widget.wantKeepAlive;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider.value(
      value: model,
      child: Consumer<T>(
        builder: (BuildContext context, T curModel, Widget? child) {
          if (curModel.isLoading) {
            return const SizedBox();
          } else {
            return widget.builder(context, curModel, child);
          }
        },
        child: widget.child,
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    logger.d("on app lifecycle change $state");
    super.didChangeAppLifecycleState(state);
    if (widget.onChangeAppLifecycleState != null) {
      widget.onChangeAppLifecycleState!(model, state);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    logger.d("did change base dependencies");
    if (widget.didChangeDependencies != null) {
      widget.didChangeDependencies!(model);
    }
  }

  @override
  void didUpdateWidget(BaseView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.didUpdateWidget != null) {
      widget.didUpdateWidget!(model, oldWidget);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.onChangeAppLifecycleState != null) {
      WidgetsBinding.instance.removeObserver(this);
    }
    if (widget.onModelDisposed != null) {
      widget.onModelDisposed!(model);
    }
  }

  @override
  initState() {
    if (widget.onModelReady != null) {
      widget.onModelReady!(model);
    }

    if (widget.onChangeAppLifecycleState != null) {
      WidgetsBinding.instance.addObserver(this);
    }

    super.initState();
  }
}
