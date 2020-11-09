import 'package:aby/model/paths.dart';
import 'package:aby/model/project.dart';
import 'package:aby/model/user.dart';
import 'package:aby/model/util.dart';
import 'package:aby/screens/404.dart';
import 'package:aby/screens/add.dart';
import 'package:aby/screens/login.dart';
import 'package:aby/screens/project.dart';
import 'package:aby/screens/projects.dart';
import 'package:aby/widgets/drawer.dart';
import 'package:aby/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AbyRouteInfoParser extends RouteInformationParser<PathConfig> {
  @override
  Future<PathConfig> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);
    final segments = uri.pathSegments;
    final sAmount = uri.pathSegments.length;
    // '/'
    if (sAmount == 0) return PathConfig.projects();
    // /oauth, /login, /add
    if (sAmount == 1) {
      if (segments[0] == 'add') return PathConfig.add();
      if (segments[0] == 'login') return PathConfig.login();
    }
    // /prj/*
    if (segments[0] == 'projects' && sAmount >= 3) {
      var prjId = segments[1];
      if (segments[2] == 'permissions') return PathConfig.permissions(prjId);
      if (segments[2] == 'settings') return PathConfig.options(prjId);
      if (segments[2] == 'folder' && sAmount >= 4) {
        var folderId = int.tryParse(segments[3]);
        if (folderId != null) {
          if (sAmount == 4) return PathConfig.files(prjId, folderId);
          if (sAmount >= 5) {
            if (segments[4] == 'settings') return PathConfig.folder(prjId, folderId);
            var fileId = int.tryParse(segments[4]);
            if (fileId != null) {
              if (sAmount == 5) return PathConfig.files(prjId, folderId);
              if (sAmount == 6) return PathConfig.file(prjId, folderId, fileId); // settings
            }
          }
        }
      }
    }
    // /translate/*
    if (segments[0] == 'translate' && sAmount <= 3) {
      var fileId = int.tryParse(segments[1]);
      if (fileId != null) {
        // if (sAmount == 2) return AbyRoutePath.translate(fileId);
        // if (segments[2] == 'settings') return AbyRoutePath.translate(fileId);
      }
    }
    // unknown routes
    return PathConfig.unknown();
  }

  @override
  RouteInformation restoreRouteInformation(PathConfig pathConfig) {
    // print('PATH CONFIG IS ${pathConfig.currentPath}');
    return RouteInformation(location: pathConfig.currentPath);
  }
}

class AbyRouterDelegate extends RouterDelegate<PathConfig>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<PathConfig> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final AuthUser _appUser;
  PathConfig _config = PathConfig.unknown();

  AbyRouterDelegate(this._appUser) {
    _appUser.addListener(notifyListeners);
  }

  @override
  PathConfig get currentConfiguration {
    print('CURRENT CONFIG IS ! ! ! ${_config.currentPath}');
    return _appUser.user != null ? _config : PathConfig.login();
  }

  @override
  Future<void> setNewRoutePath(PathConfig pathConfig) async {
    // print('CHANGING PATH FROM URL ! ! ! ${pathConfig.currentPath}');
    if (_appUser.isAuth) {}
    _config = _appUser.isAuth ? pathConfig : PathConfig.login();
    notifyListeners();
  }

  Future<void> changeNavPath(PathConfig newPathCfg) async {
    // print('NEW PATH FROM STATE ! ! ! ${newPathCfg.currentPath}');
    _config = newPathCfg;
    notifyListeners();
  }

  List<Page> get _pages {
    List<Page> pages = [
      if (_appUser.isAuth)
        buildPage(ProjectsListScreen(changePageCfg: changeNavPath), ValueKey('projects'), title: 'Projects')
      else
        MaterialPage(key: ValueKey('login'), child: LoginScreen(appUserLogin: _appUser.login))
    ];
    if (_appUser.isAuth) {
      if (_config.isSettings) pages.add(buildPage(UnknownScreen(), ValueKey('settings')));
      if (_config.isAdd) pages.add(buildPage(AddProjectScreen(), ValueKey('add'), title: 'Add project'));
      if (_config.isProject) pages.add(buildPage(ProjectDetailsScreen(prjId: _config.prjId), ValueKey('settings')));
    }
    // print('PAGES STACK ${pages.length}');
    return pages;
  }

  Page buildPage(Widget widget, Key key, {String title}) {
    var _title = title != null ? title : 'Abyss localize';
    return MaterialPage(
      key: key,
      child: _PageSizeWrapper(
        page: widget,
        changePageCfg: changeNavPath,
        title: _title,
        user: _appUser.user,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // if (context.watch<AuthUser>().user != null) setNewRoutePath(PathConfig.projects());
    return Navigator(
      key: navigatorKey,
      pages: _pages,
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        _config = _config.popPathCfg();
        // print('POPED CONFIG PATH ARE ${_config.currentPath}');
        // Update the list of pages by setting _selectedBook to null
        notifyListeners();
        return true;
      },
    );
  }
}

// Page loginPage(loginFn) {
//   return MaterialPage(key: ValueKey('login'), child: LoginScreen(appUserLogin: loginFn));
// }

class _PageSizeWrapper extends StatelessWidget {
  final changePageCfg;
  final user;
  final Widget page;
  final String title;
  const _PageSizeWrapper({Key key, this.page, this.title = 'Abyss localize', this.changePageCfg, this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // return Consumer<AuthUser>(builder: (context, user, child) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Projects>(create: (BuildContext context) => Projects(user.token)),
        ChangeNotifierProvider<AppStateUtils>(create: (BuildContext context) => AppStateUtils(user.token)),
      ],
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
            // leading: IconButton(
            //   icon: Icon(Icons.arrow_back),
            //   onPressed: () => Navigator.pop(context),
            // ),
          ),
          drawer: title == 'Projects' && width <= 600.0 ? MenuDrawer() : null,
          body: Container(
            child: Stack(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: width > 600 ? EdgeInsets.only(left: 80.0) : EdgeInsets.all(0.0),
                  child: page,
                ),
                width > 600 ? NavBar(changeNavCfg: changePageCfg, user: user) : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
    //   child: MaterialApp.router(
    //     title: appTitle,
    //     theme: applicationThemeDark,
    //     routeInformationParser: _routeParser,
    //     routerDelegate: _routerDelegate,
    //   ),
    // );
    // return SafeArea(
    //   child: Scaffold(
    //     appBar: AppBar(
    //       title: Text(title),
    //       // leading: IconButton(
    //       //   icon: Icon(Icons.arrow_back),
    //       //   onPressed: () => Navigator.pop(context),
    //       // ),
    //     ),
    //     drawer: title == 'Projects' && width <= 600.0 ? MenuDrawer() : null,
    //     body: Container(
    //       child: Stack(
    //         children: [
    //           page,
    //           width > 600 ? NavBar(changeNavCfg: changePageCfg, user: user) : SizedBox(),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
//
// class PageAuthWrapper extends Page {
//   final PathConfig config;
//   PageAuthWrapper({this.config}) : super(key: ValueKey(config));
//
//   Route createRoute(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final projects = context.watch<Projects>();
//     final languages = context.select<Utils, List>((value) => value.languages);
//     if (user.token == null) => MaterialPageRoute(
//       settings: this, builder: (BuildContext context)
//     )
//     return MaterialPageRoute(
//       settings: this,
//       builder: (BuildContext context) {
//         return screen;
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final projects = context.watch<Projects>();
//     final languages = context.select<Utils, List>((value) => value.languages);
//     return Consumer<AuthUser>(builder: (context, user, child) {
//       if (user.token == null) {
//         Navigator.pushNamed(context, '/login');
//         return null;
//       }
//       return SafeArea(
//         child: Scaffold(
//           appBar: AppBar(
//             title: Text(title),
//           ),
//           drawer: width <= 600.0 ? MenuDrawer() : null,
//           body: Stack(
//             children: [
//               projects.list != null && languages != null ? page : SplashScreen(),
//               width > 600 ? NavBar() : SizedBox(),
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }
