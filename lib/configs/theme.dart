import 'package:flutter/material.dart';

import 'constants.dart';

ThemeData applicationThemeDark = ThemeData(
  brightness: Brightness.dark,
);

ThemeData applicationThemeLight = ThemeData(
  brightness: Brightness.light,
  // primaryColor: Color.fromRGBO(0, 0, 0, 1.0),
  // primaryColor: primaryColor,
  // scaffoldBackgroundColor: backgroundColor,
  // bottomAppBarColor: Colors.deepPurple,
  // primaryColorLight: Color.fromRGBO(222, 222, 222, 1.0),
  // primaryColorDark: Color.fromRGBO(111, 111, 111, 1.0),
  // canvasColor: Color.fromRGBO(255, 0, 0, 1.0),
  // shadowColor: Color.fromRGBO(0, 0, 0, 1.0),
  // cardColor: Colors.orange.shade100,
  primarySwatch: Colors.blue,

  fontFamily: fontNameDefault,
  // textTheme: TextTheme(
  //   headline1: TextStyle(
  //     fontSize: 72,
  //     letterSpacing: 2,
  //     fontWeight: FontWeight.bold,
  //     shadows: [Shadow(color: Colors.black12, offset: Offset(2, 1))],
  //   ),
  //   headline3: TextStyle(
  //     // Screen headline
  //     fontFamily: fontNameTitle,
  //     fontSize: mediumTextSize,
  //     fontWeight: FontWeight.w800,
  //   ),
  //   headline4: TextStyle(
  //     // Main section size
  //     fontFamily: fontNameTitle,
  //     fontSize: mediumTextSize,
  //     fontWeight: FontWeight.w800,
  //     color: Colors.red,
  //   ),
  //   headline6: TextStyle(
  //       // AppBar title
  //       fontFamily: fontNameTitle,
  //       fontSize: mediumTextSize,
  //       color: Colors.purple),
  //   bodyText1: TextStyle(
  //       fontFamily: fontNameDefult,
  //       fontSize: bodyTextSize,
  //       color: Colors.green),
  // ),

  // primaryIconTheme: IconThemeData(
  //   color: Colors.red,
  //   size: 24,
  // ),

  // floatingActionButtonTheme: FloatingActionButtonThemeData(
  //     backgroundColor: Colors.red, foregroundColor: Colors.white),

  // accentColor: Color.fromRGBO(0, 0, 255, 1.0),
  // buttonTheme: ButtonThemeData(
  //     height: 50, buttonColor: Colors.blue, textTheme: ButtonTextTheme.accent),
  // visualDensity: VisualDensity.adaptivePlatformDensity,
);
