import 'package:flutter/material.dart';
import 'package:just_share/enum/view_state.dart';
import 'package:just_share/service/navigation_service.dart';

import 'getit.dart';

class BaseModel extends ChangeNotifier {
  final navigationService = getIt<NavigationService>();
  ViewState _state = ViewState.finished;
  String? _msg;

  bool get isLoading => _state == ViewState.loading;
  String? get message => _msg;
  ViewState get state => _state;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  setStateFinished() {
    _msg = null;
    setState(ViewState.finished);
  }

  setStateLoading() => setState(ViewState.loading);

  stateLoadingWithMsg(String message) {
    _msg = message;
    setState(ViewState.loading);
  }
}
