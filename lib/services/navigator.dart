import 'package:aby/model/project.dart';
import 'package:aby/screens/404.dart';
import 'package:aby/screens/project.dart';
import 'package:aby/screens/projects.dart';
import 'package:flutter/material.dart';

// class ProjectDetailPage extends Page {
//   final WidgetBuilder builder;
//   const ProjectDetailPage({@required this.builder, String name, Key key})
//       : super(key: key, name: name);
//
//   @overrider
//   Route createRoute(BuildContext context) {
//     return MaterialPageRoute(settings: this, builder: builder);
//   }
// }

// class BooksApp extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _BooksAppState();
// }
//
// class _BooksAppState extends State<BooksApp> {
//   BookRouterDelegate _routerDelegate = BookRouterDelegate();
//   AbyRouteInfoParser _routeInformationParser = AbyRouteInfoParser();
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       title: 'Abyss localize',
//       routerDelegate: _routerDelegate,
//       routeInformationParser: _routeInformationParser,
//     );
//   }
// }

class AbyRouteInfoParser extends RouteInformationParser<AbyRoutePath> {
  @override
  Future<AbyRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);
    final segments = uri.pathSegments;
    final sAmount = uri.pathSegments.length;
    // '/'
    if (sAmount == 0) return AbyRoutePath.prjList();
    // /oauth, /login, /add
    if (sAmount == 1) {
      if (segments[0] == 'add') return AbyRoutePath.add();
      if (segments[0] == 'login') return AbyRoutePath.login();
    }
    // /prj/*
    if (segments[0] == 'prj' && sAmount >= 3) {
      if (segments[2] == 'permissions')
        return AbyRoutePath.prjPerms(segments[1]);
      if (segments[2] == 'settings')
        return AbyRoutePath.prjSettings(segments[1]);
      if (segments[2] == 'folder' && sAmount >= 4) {
        var folderId = int.tryParse(segments[3]);
        if (folderId != null) {
          if (sAmount == 4) return AbyRoutePath.folder(segments[1], folderId);
          if (sAmount >= 5) {
            if (segments[4] == 'settings')
              return AbyRoutePath.folderDetail(segments[1], folderId);
            var fileId = int.tryParse(segments[4]);
            if (fileId != null) {
              if (sAmount == 5)
                return AbyRoutePath.file(segments[1], folderId, fileId);
              if (sAmount == 6)
                return AbyRoutePath.fileDetail(segments[1], folderId, fileId);
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

      if (segments[2] == 'permissions')
        return AbyRoutePath.prjPerms(segments[1]);
      if (segments[2] == 'settings')
        return AbyRoutePath.prjSettings(segments[1]);
      if (segments[2] == 'folder' && sAmount >= 4) {
        var folderId = int.tryParse(segments[3]);
        if (folderId != null) {
          if (sAmount == 4) return AbyRoutePath.folder(segments[1], folderId);
          if (sAmount >= 5) {
            if (segments[4] == 'settings')
              return AbyRoutePath.folderDetail(segments[1], folderId);
            var fileId = int.tryParse(segments[4]);
            if (fileId != null) {
              if (sAmount == 5)
                return AbyRoutePath.file(segments[1], folderId, fileId);
              if (sAmount == 6)
                return AbyRoutePath.fileDetail(segments[1], folderId, fileId);
            }
          }
        }
      }
    }
    // unknown routes
    return AbyRoutePath.unknown();
  }

  @override
  RouteInformation restoreRouteInformation(AbyRoutePath path) {
    if (path.isUnknown) {
      return RouteInformation(location: '/404');
    }
    if (path.root == 'login') {
      return RouteInformation(location: '/login');
    }
    if (path.root == 'add') {
      return RouteInformation(location: '/add');
    }
    if (path.root == null) {
      return RouteInformation(location: '/prj');
    }
    if (path.root == 'prj') {
      return RouteInformation(location: '/prj/${path.id}');
    }
    return null;
  }
}

class BookRouterDelegate extends RouterDelegate<AbyRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AbyRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  Project _selectedProject;
  bool show404 = false;

  List<Project> projects = [
    Project('Stranger in a Strange Land', 'Robert A. Heinlein'),
    Project('Foundation', 'Isaac Asimov'),
    Project('Fahrenheit 451', 'Ray Bradbury'),
  ];

  BookRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  AbyRoutePath get currentConfiguration {
    if (show404) {
      return AbyRoutePath.unknown();
    }
    return _selectedProject == null
        ? AbyRoutePath.home()
        : AbyRoutePath.details(projects.indexOf(_selectedProject));
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          key: ValueKey('BooksListPage'),
          child: ProjectsListScreen(),
        ),
        if (show404)
          MaterialPage(key: ValueKey('UnknownPage'), child: UnknownScreen())
        else if (_selectedProject != null)
          ProjectDetailsPage(project: _selectedProject)
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        // Update the list of pages by setting _selectedBook to null
        _selectedProject = null;
        show404 = false;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AbyRoutePath path) async {
    if (path.isUnknown) {
      _selectedProject = null;
      show404 = true;
      return;
    }

    if (path.isDetailsPage) {
      if (path.id < 0 || path.id > projects.length - 1) {
        show404 = true;
        return;
      }

      _selectedProject = projects[path.id];
    } else {
      _selectedProject = null;
    }

    show404 = false;
  }

  void _handleBookTapped(Project book) {
    _selectedProject = book;
    notifyListeners();
  }
}

class AbyRoutePath {
  // oauth
  // login
  // add
  // / => prj list
  // prj/:save_id/permissions
  // prj/:save_id/settings
  // prj/:save_id/folder/:folder_id/
  // prj/:save_id/folder/:folder_id/settings
  // prj/:save_id/folder/:folder_id/:file_id    mb -page ?
  // prj/:save_id/folder/:folder_id/:file_id/settings  - not set
  // translate/:file_id
  // translate/:file_id/:translate_id    mb -page ?
  // translate/:file_id/:search results ?

  final String root;
  final String prjId;
  final String option;
  final int folderId;
  final int fileId;
  final bool isDetail;
  final bool isUnknown;

  AbyRoutePath.login()
      : root = 'login',
        prjId = null,
        option = null,
        folderId = null,
        fileId = null,
        isDetail = false,
        isUnknown = false;

  AbyRoutePath.add()
      : root = 'add',
        prjId = null,
        option = null,
        folderId = null,
        fileId = null,
        isDetail = false,
        isUnknown = false;

  AbyRoutePath.prjList()
      : root = null,
        prjId = null,
        option = null,
        folderId = null,
        fileId = null,
        isDetail = false,
        isUnknown = false;

  AbyRoutePath.prjPerms(this.prjId)
      : root = 'prj',
        option = 'permissions',
        folderId = null,
        fileId = null,
        isDetail = false,
        // true if all settings in detail
        isUnknown = false;

  AbyRoutePath.prjSettings(this.prjId)
      : root = 'prj',
        option = 'settings',
        folderId = null,
        fileId = null,
        isDetail = false,
        isUnknown = false;

  AbyRoutePath.folder(this.prjId, this.folderId)
      : root = 'prj',
        option = 'folder',
        fileId = null,
        isDetail = false,
        isUnknown = false;

  AbyRoutePath.folderDetail(this.prjId, this.folderId)
      : root = 'prj',
        option = 'folder',
        fileId = null,
        isDetail = true,
        isUnknown = false;

  AbyRoutePath.file(this.prjId, this.folderId, this.fileId)
      : root = 'prj',
        option = 'folder',
        isDetail = false,
        isUnknown = false;

  AbyRoutePath.fileDetail(this.prjId, this.folderId, this.fileId)
      : root = 'prj',
        option = 'folder',
        isDetail = true,
        isUnknown = false;

  AbyRoutePath.translate(this.fileId)
      : root = 'translate',
        prjId = null,
        option = null,
        folderId = null,
        isDetail = false,
        isUnknown = true;

  AbyRoutePath.unknown()
      : root = null,
        prjId = null,
        option = null,
        folderId = null,
        fileId = null,
        isDetail = false,
        isUnknown = true;
}
