import 'package:aby/model/navigation.dart';
import 'package:aby/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' as rive;

class MenuDrawer extends StatelessWidget {
  final String title;

  MenuDrawer({Key key, this.title});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ListView(
            shrinkWrap: true,
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              // _DrawerHead(),
              Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: navItems.length,
                  itemBuilder: (context, index) {
                    return _DrawerItem(title: navItems[index].title, icon: navItems[index].icon);
                  },
                ),
              ),
            ],
          ),
          Container(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: navItemsDefault.length,
              itemBuilder: (context, index) {
                return _DrawerItem(title: navItemsDefault[index].title, icon: navItemsDefault[index].icon);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerHead extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: <Color>[Colors.deepOrange, Colors.orangeAccent]),
      ),
      child: Container(
        child: Column(
          children: [
            // SizedBox(width: 100.0, height: 100.0, child: RivePerson()),
            Material(
              borderRadius: BorderRadius.circular(50.0),
              elevation: 12,
              child: SizedBox(width: 100.0, height: 100.0, child: RivePerson()),
            ),
            Text(context.select((AuthUser user) => user.user.name), style: Theme.of(context).textTheme.headline5),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  const _DrawerItem({@required this.title, @required this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 24.0),
      title: Text(
        title,
        style: Theme.of(context).textTheme.subtitle1,
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}

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
