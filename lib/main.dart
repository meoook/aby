import 'package:aby/screens/login.dart';
import 'package:aby/screens/projects.dart';
import 'package:aby/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'configs/constants.dart';
import 'configs/theme.dart';
import 'model/project.dart';
import 'model/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthUser>(create: (_) => AuthUser()),
        ChangeNotifierProxyProvider<AuthUser, Projects>(
          // create: (context) => Projects(),
          create: (context) => null,
          update: (context, user, projects) => Projects(user.token),
          // update: (context, user, projects) => projects.setToken(user.token),
        ),
      ],
      child: MaterialApp(
        title: appTitle,
        theme: applicationThemeDark,
        home: AuthOrLogin(),
      ),
    );
    // return ChangeNotifierProvider(
    //   create: (context) => AuthUser(),
    //   child: MaterialApp(
    //     title: appTitle,
    //     theme: applicationThemeDark,
    //     home: AuthOrLogin(),
    //   ),
    // );
  }
}

class AuthOrLogin extends StatefulWidget {
  @override
  _AuthOrLoginState createState() => _AuthOrLoginState();
}

class _AuthOrLoginState extends State<AuthOrLogin> {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthUser>();
    final projects = context.watch<Projects>();
    // return Consumer<AuthUser>(builder: (context, user, child) {
    if (user.token == null) return LoginScreen();
    // if (user.user == null) {
    //   user.auth();
    // } else if (projects.list == null) {
    //   print('WOWOWOW USER IS OK BUT LIST IS NULL');
    // }
    return (projects.list != null) ? ProjectsListScreen() : SplashScreen();
    // });
  }
}
