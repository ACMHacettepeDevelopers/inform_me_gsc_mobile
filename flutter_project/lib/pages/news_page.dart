// HOME PAGE
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/custom_text_style.dart';
import '../podcast_properties.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final TextEditingController searchController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;
  String transcriptText = '';
  String translations = 'Tech,Politics,Economy,Sports';
  String category = '';
  late Future<String> future;
  String recordFilePath = '';
  bool isComplete = true;

  @override
  void initState() {
    future = translateCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 56),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder<String>(
                    future: future,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.all(4),
                            itemCount: translations.split(',').length,
                            itemBuilder: (context, index) {
                              final c = translations.split(',')[index];
                              return Column(
                                children: [
                                  categoryButton(context, c),
                                  const SizedBox(width: 16),
                                ],
                              );
                            });
                      }
                      return Center(
                        child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor),
                      );
                    }),
              ),
              if (category.isNotEmpty) searchWidget(),
            ],
          ),
        ),
      ),
      body: category.isNotEmpty ? newsWidget() : const SizedBox(),
    );
  }

  Padding searchWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () {
              handleSpeechToText();
            },
            icon: Icon(
              isComplete ? Icons.mic : Icons.stop_circle_outlined,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(hintText: 'Search'),
              controller: searchController,
            ),
          ),
          IconButton(
              onPressed: () async {
                if (searchController.text.isNotEmpty) {
                  handleCategorySelection(searchController.text);
                  searchController.text = '';
                  setState(() {});
                }
              },
              icon: Icon(
                Icons.search,
                color: Theme.of(context).primaryColor,
              ))
        ],
      ),
    );
  }

  Widget categoryButton(BuildContext context, String c) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).primaryColor,
          ),
        ),
        child: Text(
          c,
          style: TextStyle(
              color: c == category
                  ? Theme.of(context).primaryColor
                  : Colors.black),
        ),
      ),
      onTap: () => handleCategorySelection(c),
    );
  }

  void showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget newsWidget() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(category, style: CustomTextStyle.titleStyle),
        const Divider(),
        transcriptText != ''
            ? Text(
                transcriptText,
                style: CustomTextStyle.transcriptStyle,
              )
            : const Text("Loading..."),
      ],
    );
  }

  // SPEECH TO TEXT
  void handleSpeechToText() async {
    if (isComplete) {
      showSnackbar(context, "Recording...");
      await startRecord();
    } else {
      await stopRecord();
      showSnackbar(context, "Recording completed, uploading mp3...");
      await uploadMP3();
      showSnackbar(context, "Recording completed, searching...");
    }
  }

  Future<void> startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      recordFilePath = await getFilePath();
      RecordMp3.instance.start(recordFilePath, (type) {});
      isComplete = false;
      setState(() {});
    } else {
      debugPrint("No microphone permission");
    }
    setState(() {});
  }

  Future<void> stopRecord() async {
    bool s = RecordMp3.instance.stop();
    if (s) {
      showSnackbar(context, "Record complete");
      isComplete = true;
      setState(() {});
      await getTextFromSpeech();
    }
  }

  Future<String> getFilePath() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = "${storageDirectory.path}/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return "$sdPath/test_$uid.mp3";
  }

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  // CATEGORY SELECTION WITH BUTTONS
  void handleCategorySelection(String selectedCategory) async {
    debugPrint('Selected category in HomePage: $selectedCategory');
    PodcastProperties.query = selectedCategory.toLowerCase();
    category = selectedCategory;
    setState(() {});
    await handleMP3();
  }

  // HTTP REQUESTS
  Future<String> translateCategories({bool debug = false}) async {
    final user = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.email)
        .get();

    final userCountry = user.data()!['country'];
    PodcastProperties.country = userCountry;

    if (userCountry != 'US') {
      // if US do not translate
      PodcastProperties.mode = debug ? 'debug' : 'release';
      PodcastProperties.query = translations;
      final response = await http
          .get(Uri.parse(PodcastProperties.getCategoryTranslateURL()));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final responsetranslations = jsonResponse['translations'];
        translations = responsetranslations;
        category = translations.split(',')[0];
        PodcastProperties.query = category.toLowerCase();
        setState(() {});
        handleMP3();
        return responsetranslations;
      } else {
        //throw Exception('Failed to load translations');
        debugPrint("ERRORRR");
      }
    } else {
      translations = 'Tech,Politicis,Economy,Sports';
      setState(() {});
    }
    return '';
  }

  Future<String> getTranscriptText() async {
    if (category.isEmpty) return '';
    final uid = FirebaseAuth.instance.currentUser?.uid;
    http.Response response =
        await http.get(Uri.parse(PodcastProperties.getTranscriptURL(uid)));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return '';
    }
  }

  Future<void> handleMP3() async {
    transcriptText = '';
    setState(() {});
    if (category.isEmpty) return;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final response = await http.get(Uri.parse(PodcastProperties.getURL(uid)));

    if (response.statusCode == 200) {
      PodcastProperties.mp3 = response.bodyBytes; // Load a mp3
      transcriptText = await getTranscriptText();
      setState(() {});
    } else {
      PodcastProperties.mp3 = null;
    }
  }

  Future<void> uploadMP3() async {
    if (isComplete && recordFilePath != '') {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final recordBase64 = base64Encode(File(recordFilePath).readAsBytesSync());
      final response = await http.post(
        Uri.parse(PodcastProperties.getMP3UploadURL(uid)),
        headers: {'mp3': recordBase64},
      );

      if (response.statusCode == 200) {
        debugPrint(response.body);
        if (!mounted) return;
        debugPrint('MP3 Yüklendi');
        await getTextFromSpeech();
      } else {
        if (!mounted) return;
        showSnackbar(context, 'MP3 Yüklenirken bi hata oluştu');
      }
    }
  }

  Future<void> getTextFromSpeech() async {
    if (isComplete && recordFilePath != '') {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final response =
          await http.get(Uri.parse(PodcastProperties.getSpeechToTextURL(uid)));

      if (response.statusCode == 200) {
        debugPrint(response.body);
        final query = response.body.split(':')[1].split('}')[0];
        handleCategorySelection(query);
      } else {
        transcriptText = 'Speech Error!';
      }
    }
  }
}
