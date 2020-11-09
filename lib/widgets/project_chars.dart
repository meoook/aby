import 'package:flutter/material.dart';

import '../configs/utils.dart';

class ProjectIconChars extends StatelessWidget {
  const ProjectIconChars({@required this.iChars, this.size = 24});
  final String iChars;
  final double size;

  @override
  Widget build(BuildContext context) {
    final _chars = iChars.length >= 2 ? iChars.capitalize().substring(0, 2) : iChars.capitalize();
    return Container(
      width: size * 2.3,
      height: size * 2,
      alignment: Alignment.center,
      child: Text(
        _chars,
        style: TextStyle(
          fontSize: size,
          letterSpacing: size / 8,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = size / 12
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
