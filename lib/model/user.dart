import 'dart:convert';
import 'dart:io';

import 'package:aby/configs/constants.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthUser with ChangeNotifier {
  final _secureStorage = new FlutterSecureStorage();
  bool get _allowedPlatform {
    if (kIsWeb) {
      print('OS IS WEB');
      return false;
    } else {
      try {
        print('TRY Mobile');
        if (Platform.isAndroid || Platform.isIOS) return true;
      } catch (e) {
        print('NOT Mobile');
      }
    }
    return false;
  }

  _AppUser _appUser;
  _AppUser get user => _appUser;
  String _error;
  String get error => _error;
  String _token;
  String get token => _token;

  bool get isAuth => user != null;

  AuthUser() {
    print('INITING AUTH USER');
    _authWithStorageToken();
  }
  Future _authWithStorageToken() async {
    if (_token == null) {
      print('No token - getting');
      if (_allowedPlatform) {
        String value = await _secureStorage.read(key: 'abyssLocalizeToken');
        print('Storage value is $value');
        if (value.isNotEmpty) {
          print('AUTH');
          _token = value;
          await _auth();
          notifyListeners();
        }
      } else {
        print('Can\'t get - not allowed platform');
      }
    }
  }

  Future<void> _auth() async {
    if (_token != null) return;
    print('Try to auth with $_token');
    _error = null;
    final response = await http.get(
      '$apiUrlAddress/auth/user',
      headers: {HttpHeaders.authorizationHeader: "Token $_token"},
    );
    if (response.statusCode == 200)
      await _userCreate(response);
    else
      await _userDestroy();
  }

  void login({String username, String password}) async {
    print('Try to login with $username $password');
    _error = null;
    final response = await http.post(
      '$apiUrlAddress/auth/login',
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      },
      body: jsonEncode(<String, String>{
        "username": username,
        "password": password,
      }),
    );
    if (response.statusCode == 200) {
      await _userCreate(response);
    } else {
      _error = 'Username or password are incorrect';
    }
    notifyListeners();
  }

  void logout() async {
    _error = null;
    final response = await http.get(
      '$apiUrlAddress/auth/logout',
      headers: {
        HttpHeaders.authorizationHeader: "Token ${_appUser.token}",
        HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      },
    );
    if (response.statusCode != 200) _error = 'Failed to logout';

    await _userDestroy();
    notifyListeners();
  }

  Future<void> _userCreate(resp) async {
    final responseJson = jsonDecode(resp.body);
    _appUser = _AppUser.fromJson(responseJson);
    _token = _appUser.token;
    if (_allowedPlatform) await _secureStorage.write(key: 'abyssLocalizeToken', value: _token);
  }

  Future<void> _userDestroy() async {
    _appUser = null;
    _token = '';
    if (_allowedPlatform) await _secureStorage.delete(key: 'abyssLocalizeToken');
  }
}

class _AppUser {
  final int id;
  final String name;
  final String email;
  final String token;
  final bool isCreator;

  _AppUser({
    this.id,
    this.name,
    this.email,
    this.token,
    this.isCreator,
  });

  factory _AppUser.fromJson(Map<String, dynamic> json) {
    return _AppUser(
      id: json['user']['id'],
      name: json['user']['username'],
      email: json['user']['email'],
      isCreator: json['user']['role'] == 'creator',
      token: json['token'],
    );
  }
}
