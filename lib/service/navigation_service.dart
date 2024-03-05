import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future navigateTo(String routeName, {Object? arguments, bool withreplacement = false, bool isAsRoot = false}) {
    if (withreplacement) {
      return navigatorKey.currentState!.pushNamedAndRemoveUntil(routeName, (route) {
        return route.isFirst;
      }, arguments: arguments);
    } else if (isAsRoot) {
      return navigatorKey.currentState!.pushNamedAndRemoveUntil(routeName, (route) => false, arguments: arguments);
    } else {
      return navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
    }
  }

  bool pop() {
    navigatorKey.currentState!.pop();

    return true;
  }
}
