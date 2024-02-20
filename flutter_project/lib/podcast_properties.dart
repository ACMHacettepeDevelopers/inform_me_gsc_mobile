class PodcastProperties {
  static const String baseUrl = "http://127.0.0.1:5000/create_podcast?country=US&query=economy&count=10&podcast_file_name=podcast.mp3&mode=debug";
  static String country = "US";
  static String query = "economy";
  static String count = "10";
  static String mode = "debug";
  
  static getURL(uid) {
    return "http://127.0.0.1:5000/create_podcast?country=$country&query=$query&count=$count&podcast_file_name=$uid&mode=$mode";
  }
}