import 'package:aby/model/project.dart';
import 'package:flutter/material.dart';

class ProjectDetailsPage extends Page {
  final Project project;

  ProjectDetailsPage({
    this.project,
  }) : super(key: ValueKey(project));

  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return _ProjectDetailsScreen(project: project);
      },
    );
  }
}

class _ProjectDetailsScreen extends StatelessWidget {
  final Project project;

  _ProjectDetailsScreen({
    @required this.project,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (project != null) ...[
              Text(project.name, style: Theme.of(context).textTheme.headline6),
              Text(project.iChars,
                  style: Theme.of(context).textTheme.subtitle1),
            ],
          ],
        ),
      ),
    );
  }
}
