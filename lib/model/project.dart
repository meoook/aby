import 'dart:convert';
import 'dart:io';

import 'package:aby/configs/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Projects with ChangeNotifier {
  String _token;
  List<Project> _projects;

  List<Project> get list => _projects;

  Projects(token) {
    print('Inited projects - setting token $token');
    if (token != null) {
      _token = token;
      print('TOKEN IN PROJECT IS OK $_token');
      _fetchProjects();
    }
  }

  // Projects setToken(String token) {
  //   print('Inited projects - setting token $token');
  //   if (token != null) {
  //     _token = token;
  //     print('TOKEN IN PROJECT IS OK $_token');
  //     _fetchProjects();
  //   }
  //   return this;
  // }

  void _fetchProjects() async {
    final response = await http.get(
      '$apiUrlAddress/prj',
      headers: {
        HttpHeaders.authorizationHeader: "Token $_token",
      },
    );
    if (response.statusCode < 300) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      _projects =
          parsed.map<Project>((json) => Project.fromJson(json)).toList();
      print('Projects get ${_projects.length} amount');
      notifyListeners();
    }
  }
}

class Project {
  final String id;
  final String name;
  final String iChars;
  final String author;
  final DateTime created;
  final int langOriginal;
  final List<dynamic> translateTo;
  final List<dynamic> permissions;

  Project(
      {this.id,
      this.name,
      this.iChars,
      this.author,
      this.created,
      this.langOriginal,
      this.translateTo,
      this.permissions});

  factory Project.fromJson(Map<String, dynamic> json) {
    print('New project loaded ${json.keys.toString()}');
    // [ for (var key_name in json.keys ) print(key_name)];
    json.keys.forEach((element) {
      print('$element ${json[element]}');
    });
    return Project(
      id: json['save_id'],
      name: json['name'],
      iChars: json['icon_chars'],
      author: json['author'],
      created: DateTime.parse(json['created']),
      langOriginal: json['lang_orig'],
      translateTo: json['translate_to'],
      permissions: json['permissions_set'],
    );
  }
}
