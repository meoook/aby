import 'package:aby/services/navigator.dart';
import 'package:flutter/material.dart';

import 'configs/constants.dart';
import 'configs/theme.dart';
import 'model/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static AuthUser appUser = AuthUser();
  final AbyRouterDelegate _routerDelegate = AbyRouterDelegate(appUser);
  final AbyRouteInfoParser _routeParser = AbyRouteInfoParser();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: appTitle,
      theme: applicationThemeDark,
      routeInformationParser: _routeParser,
      routerDelegate: _routerDelegate,
    );
  }
}
