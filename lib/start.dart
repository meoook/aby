import 'dart:async';

import 'package:aby/screens/books.dart';
import 'package:aby/screens/login.dart';
import 'package:aby/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/user.dart';

class StartAppController extends StatefulWidget {
  @override
  _StartAppControllerState createState() => _StartAppControllerState();
}

class _StartAppControllerState extends State<StartAppController> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 2),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) =>
              Provider.of<AuthUser>(context, listen: false).user != null
                  ? BooksApp()
                  : LoginScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthUser>(
      builder: (context, user, child) {
        return user.user == null ? SplashScreen() : BooksApp();
      },
    );
  }
}
