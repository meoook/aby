import 'package:aby/model/paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart' as rive;

class NavBar extends StatelessWidget {
  final changeNavCfg;
  final user;

  void navigate(String title) {
    PathConfig cfg;
    if (title == 'Add')
      cfg = PathConfig.add();
    else if (title == 'Projects')
      cfg = PathConfig.projects();
    else
      cfg = PathConfig.projects();
    changeNavCfg(cfg);
  }

  const NavBar({Key key, this.changeNavCfg, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.0,
      // height: double.maxFinite,
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: ListView(
              shrinkWrap: true,
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                _NavBarHead(user: user),
                _NavItem(title: 'Projects', icon: Icons.apartment, changeNav: navigate),
                _NavItem(title: 'Add', icon: Icons.apartment, changeNav: navigate)
              ],
            ),
          ),
          Container(
              child: Column(
            children: [
              _NavItem(title: 'Settings', icon: Icons.settings, changeNav: navigate),
              _NavItem(title: 'Sing out', icon: Icons.logout, changeNav: navigate)
            ],
          )),
        ],
      ),
    );
  }
}

// Nav Header
class _NavBarHead extends StatelessWidget {
  final user;

  const _NavBarHead({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 12.0, bottom: 8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: <Color>[Colors.deepOrange, Colors.orangeAccent]),
      ),
      child: Column(
        children: [
          Material(
            borderRadius: BorderRadius.circular(25.0),
            elevation: 12,
            child: SizedBox(width: 50.0, height: 50.0, child: RivePerson()),
          ),
          const SizedBox(height: 4.0),
          Text(user.name, style: Theme.of(context).textTheme.subtitle2),
        ],
      ),
    );
  }
}

// Nav Item
class _NavItem extends StatelessWidget {
  final changeNav;
  final String title;
  final IconData icon;
  const _NavItem({@required this.title, @required this.icon, this.changeNav});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        changeNav(title);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 24.0),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
    );
  }
}

// Rive Image
class RivePerson extends StatefulWidget {
  @override
  _RivePersonState createState() => _RivePersonState();
}

class _RivePersonState extends State<RivePerson> {
  final riveFileName = 'assets/rive/person.riv';
  rive.Artboard _artBoard;

  @override
  void initState() {
    _loadRiveFile();
    super.initState();
  }

  // loads a Rive file
  void _loadRiveFile() async {
    final bytes = await rootBundle.load(riveFileName);
    final file = rive.RiveFile();

    if (file.import(bytes)) {
      // Select an animation by its name
      setState(() => _artBoard = file.mainArtboard);
    }
  }

  /// Show the rive file, when loaded
  @override
  Widget build(BuildContext context) {
    return _artBoard != null
        ? rive.Rive(
            artboard: _artBoard,
            fit: BoxFit.contain,
          )
        : const SizedBox();
  }
}
