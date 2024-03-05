// Routes arranged in ascending order

import 'package:flutter/material.dart';
import 'package:just_share/views/home.dart';

final Map<String, WidgetBuilder> routes = {
  HomeScaffold.routeName: (_) => const HomeScaffold(),
};
