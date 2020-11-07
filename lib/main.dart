import 'package:aby/model/util.dart';
import 'package:aby/screens/404.dart';
import 'package:aby/screens/login.dart';
import 'package:aby/screens/projects.dart';
import 'package:aby/screens/starter.dart';
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
          create: (_) => null,
          update: (_, user, __) => Projects(user.token),
        ),
        ChangeNotifierProxyProvider<AuthUser, Utils>(
          create: (_) => null,
          update: (_, user, __) => Utils(user.token),
        ),
      ],
      child: MaterialApp(
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (context) => UnknownScreen(),
        ),
        onGenerateRoute: (settings) {
          if (settings.name == '/login') {
            return MaterialPageRoute(
                settings: settings, builder: (context) => LoginScreen());
          }

          return null;
        },
        routes: {
          ProjectsListScreen.routeName: (context) => ProjectsListScreen(),
          LoginScreen.routeName: (context) => LoginScreen(),
        },
        title: appTitle,
        theme: applicationThemeDark,
        home: AuthOrLogin(),
      ),
    );
  }
}
