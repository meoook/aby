import 'package:aby/model/project.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final String prjId;

  ProjectDetailsScreen({
    @required this.prjId,
  });

  @override
  Widget build(BuildContext context) {
    final projects = context.watch<Projects>();
    if (projects.list == null) return Container(child: Text("Project not found"));
    var index = projects.list.indexWhere((element) => element.id == prjId);
    if (index == null || index < 0) return Container(child: Text("Project not found"));
    final project = projects.list[index];
    return Container(
      color: Colors.red,
      width: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (project != null) ...[
              Text(project.name, style: Theme.of(context).textTheme.headline1),
              Text(project.iChars, style: Theme.of(context).textTheme.subtitle1),
            ],
          ],
        ),
      ),
    );
  }
}
