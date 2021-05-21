import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Album {
  final int id;
  final String title;
  Album({required this.id, required this.title});
  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      title: json['title'],
    );
  }
}

Future<Album> fetchAlbum() async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
  );
  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to get album');
  }
}

Future<Album> updateAlbum(String title) async {
  final response = await http.put(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
    headers: <String, String>{'Content-Type': 'application/json;charset=UTF-8'},
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );
  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('failed to update album');
  }
}

Future<Album> createAlbum(String title) async {
  final response = await http.post(
    Uri.https('jsonplaceholder.typicode.com', 'albums'),
    headers: <String, String>{
      'Content-Type': 'application/json;charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );
  if (response.statusCode == 201) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create album');
  }
}

void main() {
  runApp(MyApp());
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _controller = TextEditingController();
  late Future<Album> _futureAlbum;

  @override
  void initState() {
    super.initState();
    _futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Post data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Post Data Example'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: buildFutureBuilder(),
          //child: (_futureAlbum == null) ? buildColumn() : buildFutureBuilder(),
        ),
      ),
    );
  }

  FutureBuilder<Album> buildFutureBuilder() {
    return FutureBuilder<Album>(
      future: _futureAlbum,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(snapshot.data!.title + ' ' + snapshot.data!.id.toString()),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Enter Title To Update',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _futureAlbum = updateAlbum(_controller.text);
                    });
                  },
                  child: Text('Update Existing Data'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _futureAlbum = createAlbum(_controller.text);
                    });
                  },
                  child: Text('Create New Data'),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
        }
        return CircularProgressIndicator();
      },
    );
  }
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}
