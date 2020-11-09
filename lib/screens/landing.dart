import 'package:aby/screens/login.dart';
import 'package:aby/screens/projects.dart';
import 'package:aby/screens/splash.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  var authSuccess;

  @override
  void initState() {
    super.initState();
    // checkIfAuthenticated().then((success) {
    authSuccess = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    if (authSuccess != null) {
      if (authSuccess) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProjectsListScreen()));
      } else {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    }

    return SplashScreen();
  }
}

class BlaBla extends StatefulWidget {
  @override
  _BlaBlaState createState() => _BlaBlaState();
}

class _BlaBlaState extends State<BlaBla> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
