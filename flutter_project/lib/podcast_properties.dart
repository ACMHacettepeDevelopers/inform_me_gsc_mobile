import 'package:flutter/foundation.dart';

class PodcastProperties {
  static const String baseUrl = "http://127.0.0.1:5000";
  static String country = "US";
  static String query = "economy";
  static String count = "10";
  static String mode = "debug";
  static Uint8List? mp3;
  
  static getURL(uid) {
    return "$baseUrl/create_podcast?country=$country&query=$query&count=$count&podcast_file_name=$uid.mp3&mode=$mode";
  }

  static getTranscriptURL(uid){
    return "$baseUrl/get_transcript?podcast_file_name=$uid.mp3";
  }

   static getCategoryTranslateURL(){
    return '$baseUrl/translate_categories?categories_to_translate=$query&translation_country_code=$country&mode=$mode';
  }
}