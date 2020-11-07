import 'package:aby/model/project.dart';
import 'package:aby/screens/project.dart';
import 'package:aby/screens/wrapper.dart';
import 'package:aby/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../configs/utils.dart';

class ProjectsListScreen extends StatelessWidget {
  static const routeName = 'projects';
  @override
  Widget build(BuildContext context) {
    final projects = context.watch<Projects>().list;
    final width = MediaQuery.of(context).size.width;
    return PageSizeWrapper(
      title: 'Projects',
      page: Stack(
        children: [
          Container(
            padding: width > 600
                ? EdgeInsets.only(top: 8.0, left: 80.0)
                : EdgeInsets.only(top: 8.0),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: projects.length,
              separatorBuilder: (_, __) => Divider(),
              itemBuilder: (_, index) =>
                  _ProjectListItem(project: projects[index]),
            ),
          ),
          width > 600 ? NavBar() : SizedBox(),
        ],
      ),
    );
  }
}

class _ProjectListItem extends StatelessWidget {
  const _ProjectListItem({@required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final double itemSize = getSizeFromWidth(MediaQuery.of(context).size.width);
    final wrapper = SizedBox(width: itemSize / 2, height: itemSize);
    final double scaleFactor = itemSize / 24;
    return FlatButton(
      // onPressed: () => {Navigator.of(context).pushNamed('/prj/${project.id}')},
      onPressed: () => {
      Navigator.push(context,
        MaterialPageRoute(
        builder: (context) => ProjectDetailsPage(project: project);),
        ),
      );
    },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: itemSize / 2, vertical: itemSize / 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _IconChars(
                  iChars: project.iChars,
                  size: itemSize,
                ),
                wrapper,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(project.name,
                        textScaleFactor: scaleFactor,
                        style: Theme.of(context).textTheme.headline5),
                    Text('author: ${project.author}',
                        textScaleFactor: scaleFactor,
                        style: Theme.of(context).textTheme.subtitle1),
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
                Text(getStringDate(project.created),
                    style: Theme.of(context).textTheme.subtitle1),
              ],
            ),
          ],
        ),
      ),
    );
    //   ListTile(
    //   trailing: Text(project.created.toString()),
    //   onTap: () => {},
    //   contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
    // );
  }
}

class _IconChars extends StatelessWidget {
  const _IconChars({@required this.iChars, this.size = 24});

  final String iChars;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size * 2.3,
      height: size * 2,
      alignment: Alignment.center,
      child: Text(
        iChars.capitalize(),
        style: TextStyle(
          fontSize: size,
          letterSpacing: size / 15,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..color = Colors.white,
        ),
      ),
      // padding: EdgeInsets.only(bottom: 2.0),
      // margin: EdgeInsets.all(0.0),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.white, width: 2.0),
        color: Colors.deepPurple,
        // boxShadow: [
        //   BoxShadow(
        //       offset: Offset(1.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0)
        // ],
      ),
    );
  }
}
