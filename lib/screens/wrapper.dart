import 'package:aby/widgets/drawer.dart';
import 'package:aby/widgets/navbar.dart';
import 'package:flutter/material.dart';

class PageSizeWrapper extends StatelessWidget {
  final Widget page;
  final String title;
  const PageSizeWrapper({Key key, this.page, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        drawer: width <= 600.0 ? MenuDrawer() : null,
        body: Stack(
          children: [
            page,
            width > 600 ? NavBar() : SizedBox(),
          ],
        ),
      ),
    );
  }
}
