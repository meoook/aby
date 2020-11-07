import 'package:aby/model/project.dart';
import 'package:aby/model/user.dart';
import 'package:aby/model/util.dart';
import 'package:aby/screens/login.dart';
import 'package:aby/screens/projects.dart';
import 'package:aby/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
