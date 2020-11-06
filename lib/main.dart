import 'package:aby/model/util.dart';
import 'package:aby/screens/login.dart';
import 'package:aby/screens/projects.dart';
import 'package:aby/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/project.dart';
import 'model/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  List pages;
  bool _onPopPage(Route<dynamic> route, dynamic result) {
    pages.remove(route.settings);
    return route.didPop(result);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthUser>(create: (_) => AuthUser()),
        ChangeNotifierProxyProvider<AuthUser, Projects>(
          create: (_) => null,
          update: (_, user, __) => Projects(user.token),
        ),
        ChangeNotifierProxyProvider<AuthUser, Utils>(
          create: (_) => null,
          update: (_, user, __) => Utils(user.token),
        ),
      ],
      child: Navigator(
        pages: [],
        // onUnknownRoute: UnknownScreen(),
        onPopPage: _onPopPage,
        // child: MaterialApp(
        //   title: appTitle,
        //   theme: applicationThemeDark,
        //   home: SafeArea(child: AuthOrLogin()),
        // ),
      ),
    );
  }
}

class AuthOrLogin extends StatefulWidget {
  @override
  _AuthOrLoginState createState() => _AuthOrLoginState();
}

class _AuthOrLoginState extends State<AuthOrLogin> {
  @override
  Widget build(BuildContext context) {
    final projects = context.watch<Projects>();
    final languages = context.select<Utils, List>((value) => value.languages);
    return Consumer<AuthUser>(builder: (context, user, child) {
      if (user.token == null) return LoginScreen();
      return (projects.list != null && languages != null)
          ? ProjectsListScreen()
          : SplashScreen();
    });
  }
}
