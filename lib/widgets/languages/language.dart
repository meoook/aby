import 'package:aby/model/project.dart';
import 'package:aby/model/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class _LanguageIcon extends StatelessWidget {
  final double size;
  final String chars;

  const _LanguageIcon({Key key, this.size = 24.0, this.chars = 'eu'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: SvgPicture.asset(
          'icons/flags/svg/$chars.svg',
          package: 'country_icons',
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class LanguageNameIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final languages = context.select((AppStateUtils value) => value.languages);
    final projects = context.watch<Projects>().list;
    print('LEN LANGUAGES ${languages?.length}');
    print('LEN PROJECTS ${projects?.length}');
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _LanguageIcon(
          size: 24,
          chars: 'eu',
        ),
        const SizedBox(width: 4.0),
        Text(
          languages != null ? '${languages[0].name.toString()}' : '',
          style: Theme.of(context).textTheme.headline6,
        ),
      ],
    );
  }
}
