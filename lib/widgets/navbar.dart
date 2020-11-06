import 'package:aby/model/navigation.dart';
import 'package:aby/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' as rive;

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.0,
      height: double.maxFinite,
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ListView(
            shrinkWrap: true,
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              _NavBarHead(),
              Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: navItems.length,
                  itemBuilder: (context, index) {
                    return _NavItem(
                        title: navItems[index].title,
                        icon: navItems[index].icon);
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
                return _NavItem(
                    title: navItemsDefault[index].title,
                    icon: navItemsDefault[index].icon);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Nav Header
class _NavBarHead extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 12.0, bottom: 8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: <Color>[Colors.deepOrange, Colors.orangeAccent]),
      ),
      child: Column(
        children: [
          Material(
            borderRadius: BorderRadius.circular(25.0),
            elevation: 12,
            child: SizedBox(width: 50.0, height: 50.0, child: RivePerson()),
          ),
          const SizedBox(height: 4.0),
          Text(context.select((AuthUser user) => user.user.name),
              style: Theme.of(context).textTheme.subtitle2),
        ],
      ),
    );
  }
}

// Nav Item
class _NavItem extends StatelessWidget {
  final String title;
  final IconData icon;
  const _NavItem({@required this.title, @required this.icon});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {},
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
