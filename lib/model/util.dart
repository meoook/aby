import 'dart:convert';
import 'dart:io';

import 'package:aby/configs/constants.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AppStateUtils with ChangeNotifier {
  String _token;
  List<Language> _languages;
  List<Language> get languages => _languages;

  AppStateUtils(token) {
    if (token != null) {
      _token = token;
      print('TOKEN IN UTILS IS OK $_token');
      _fetchLanguages();
    } else {
      print('NO TOKEN IN UTILS');
    }
  }
  void _fetchLanguages() async {
    final response = await http.get(
      '$apiUrlAddress/lang',
      headers: {HttpHeaders.authorizationHeader: "Token $_token"},
    );
    print('get list of languages ${response.statusCode}');
    if (response.statusCode < 300) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      _languages = parsed.map<Language>((json) => Language.fromJson(json)).toList();
      print('Languages get ${_languages.length} amount');
      notifyListeners(); // TODO Need it here ?
    }
  }

  String get getPlatform {
    if (kIsWeb) return 'web';
    return (Platform.isAndroid || Platform.isIOS) ? 'mobile' : 'desk';
  }
}

class Language {
  final String id;
  final String name;
  final String shortName;

  Language({
    this.id,
    this.name,
    this.shortName,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: json['save_id'],
      name: json['name'],
      shortName: json['short_name'],
    );
  }
}
