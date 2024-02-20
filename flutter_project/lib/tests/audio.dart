import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<void> fetchPodcast() async {
  final response = await http.get(Uri.parse('http://127.0.0.1:5000/create_podcast?country=US&query=economy&count=10&podcast_file_name=podcast.mp3&mode=debug'));

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, save the audio file locally
    final bytes = response.bodyBytes;
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/podcast_local.mp3');
    await file.writeAsBytes(bytes);
  } else {
    // If the server returns an error response, throw an exception or handle it accordingly
    throw Exception('Failed to load podcast');
  }
}

