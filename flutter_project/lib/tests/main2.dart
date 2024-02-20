import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Podcast',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> fetchPodcast() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:5000/create_podcast?country=US&query=economy&count=10&podcast_file_name=podcast.mp3&mode=debug'));

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final dir = await getApplicationDocumentsDirectory();
      await dir.create(recursive: true);
      final file = File('${dir.path}/podcast_local.mp3');
      await file.writeAsBytes(bytes);

      // Now you have the MP3 file locally, you can play it using the audioplayers package
      // Make sure to add the proper import statement for audioplayers
    } else {
      throw Exception('Failed to load podcast');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fetch Podcast'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: fetchPodcast,
          child: Text('Fetch Podcast'),
        ),
      ),
    );
  }
}