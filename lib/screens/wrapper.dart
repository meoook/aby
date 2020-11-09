import 'package:aby/model/project.dart';
import 'package:aby/model/util.dart';
import 'package:aby/screens/splash.dart';
import 'package:aby/widgets/drawer.dart';
import 'package:aby/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageSizeWrapper extends StatelessWidget {
  final Widget page;
  final String title;
  const PageSizeWrapper({Key key, this.page, this.title = 'Abyss localize'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final projects = context.watch<Projects>();
    final languages = context.select<AppStateUtils, List>((value) => value.languages);
    // return Consumer<AuthUser>(builder: (context, user, child) {
    // if (user == null || user.token == null) {
    //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
    //   return Container();
    // }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        drawer: width <= 600.0 ? MenuDrawer() : null,
        body: Stack(
          children: [
            projects.list != null && languages != null ? page : SplashScreen(),
            width > 600 ? NavBar() : SizedBox(),
          ],
        ),
      ),
    );
    // });
  }
}
