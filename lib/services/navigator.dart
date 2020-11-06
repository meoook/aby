import 'package:aby/model/project.dart';
import 'package:aby/screens/404.dart';
import 'package:aby/screens/project.dart';
import 'package:aby/screens/projects.dart';
import 'package:flutter/material.dart';

class BooksApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BooksAppState();
}

class _BooksAppState extends State<BooksApp> {
  BookRouterDelegate _routerDelegate = BookRouterDelegate();
  ProjectRouteInfoParser _routeInformationParser = ProjectRouteInfoParser();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Abyss localize',
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
    );
  }
}

class ProjectRouteInfoParser extends RouteInformationParser<ProjectRoutePath> {
  @override
  Future<ProjectRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);
    // Handle '/'
    if (uri.pathSegments.length == 0) {
      return ProjectRoutePath.home();
    }

    // Handle '/book/:id'
    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] != 'prj') return ProjectRoutePath.unknown();
      var remaining = uri.pathSegments[1];
      var id = int.tryParse(remaining);
      if (id == null) return ProjectRoutePath.unknown();
      return ProjectRoutePath.details(id);
    }

    // Handle unknown routes
    return ProjectRoutePath.unknown();
  }

  @override
  RouteInformation restoreRouteInformation(ProjectRoutePath path) {
    if (path.isUnknown) {
      return RouteInformation(location: '/404');
    }
    if (path.isHomePage) {
      return RouteInformation(location: '/');
    }
    if (path.isDetailsPage) {
      return RouteInformation(location: '/prj/${path.id}');
    }
    return null;
  }
}

class BookRouterDelegate extends RouterDelegate<ProjectRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<ProjectRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  Project _selectedProject;
  bool show404 = false;

  List<Project> projects = [
    Project('Stranger in a Strange Land', 'Robert A. Heinlein'),
    Project('Foundation', 'Isaac Asimov'),
    Project('Fahrenheit 451', 'Ray Bradbury'),
  ];

  BookRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  ProjectRoutePath get currentConfiguration {
    if (show404) {
      return ProjectRoutePath.unknown();
    }
    return _selectedProject == null
        ? ProjectRoutePath.home()
        : ProjectRoutePath.details(projects.indexOf(_selectedProject));
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
  Future<void> setNewRoutePath(ProjectRoutePath path) async {
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

class ProjectRoutePath {
  final int id;
  final bool isUnknown;

  ProjectRoutePath.home()
      : id = null,
        isUnknown = false;

  ProjectRoutePath.details(this.id) : isUnknown = false;

  ProjectRoutePath.unknown()
      : id = null,
        isUnknown = true;

  bool get isHomePage => id == null;

  bool get isDetailsPage => id != null;
}
