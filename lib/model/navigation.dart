import 'package:flutter/material.dart';

class NavigationItemModel {
  String title;
  IconData icon;
  NavigationItemModel({this.title, this.icon});
}

List<NavigationItemModel> navItems = [
  NavigationItemModel(title: 'Projects', icon: Icons.apartment),
  NavigationItemModel(title: 'Add', icon: Icons.add_circle_outline),
];

List<NavigationItemModel> navItemsDefault = [
  NavigationItemModel(title: 'Settings', icon: Icons.settings),
  NavigationItemModel(title: 'Sing out', icon: Icons.logout),
];
