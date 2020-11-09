import 'package:aby/model/paths.dart';
import 'package:aby/model/project.dart';
import 'package:aby/screens/splash.dart';
import 'package:aby/widgets/project_chars.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../configs/utils.dart';

class ProjectsListScreen extends StatelessWidget {
  final changePageCfg;

  const ProjectsListScreen({Key key, this.changePageCfg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final projects = context.watch<Projects>();
    return FutureBuilder(
      future: projects.refreshList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.separated(
            shrinkWrap: true,
            itemCount: snapshot.data.length,
            separatorBuilder: (_, __) => Divider(),
            itemBuilder: (_, index) => _ProjectListItem(project: snapshot.data[index], changePageCfg: changePageCfg),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("Error loading projects"));
        }
        return SplashScreen();
      },
    );
  }
}

class _ProjectListItem extends StatelessWidget {
  const _ProjectListItem({@required this.project, this.changePageCfg});
  final changePageCfg;
  final Project project;
  void openProject() {
    changePageCfg(PathConfig.project(project.id));
  }

  @override
  Widget build(BuildContext context) {
    final double itemSize = getSizeFromWidth(MediaQuery.of(context).size.width);
    final wrapper = SizedBox(width: itemSize / 2, height: itemSize);
    final double scaleFactor = itemSize / 24;
    return FlatButton(
      // onPressed: () => {Navigator.of(context).pushNamed('/prj/${project.id}')},
      onPressed: () => {openProject()},
      // {Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectDetailsScreen(project: project)))},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: itemSize / 2, vertical: itemSize / 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ProjectIconChars(
                  iChars: project.iChars,
                  size: itemSize,
                ),
                wrapper,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(project.name, textScaleFactor: scaleFactor, style: Theme.of(context).textTheme.headline5),
                    Text('author: ${project.author}',
                        textScaleFactor: scaleFactor, style: Theme.of(context).textTheme.subtitle1),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text('created', style: Theme.of(context).textTheme.subtitle1),
                Text(getStringDate(project.created), style: Theme.of(context).textTheme.subtitle1),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
