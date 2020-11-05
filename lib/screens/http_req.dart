import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HttpReqApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'HttpReq Demo';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
          appBar: AppBar(
            title: Text(appTitle),
          ),
          body: HttpReqPage()),
    );
  }
}

class HttpReqPage extends StatefulWidget {
  @override
  _HttpReqPageState createState() => _HttpReqPageState();
}

class _HttpReqPageState extends State<HttpReqPage> {
  Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<Album>(
        future: futureAlbum,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text('Wow ${snapshot.data.title}');
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      ),
    );
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  Album({this.userId, this.id, this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

Future<Album> fetchAlbum() async {
  final response = await http.get(
    'https://jsonplaceholder.typicode.com/albums/3',
    headers: {
      HttpHeaders.authorizationHeader: "Basic your_api_token_here",
    },
  );

  if (response.statusCode == 200) {
    final responseJson = jsonDecode(response.body);
    return Album.fromJson(responseJson);
  } else {
    throw Exception('Failed to load album');
  }
}

Future<http.Response> deleteAlbum(String id) async {
  final http.Response response = await http.delete(
    'https://jsonplaceholder.typicode.com/albums/$id',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  return response;
}
