// HOME PAGE
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              showSnackbar(context, 'Say something');
            },
            icon: Icon(Icons.mic),
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
                  await handleMP3();
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

  void handleCategorySelection(String selectedCategory) async {
    print('Selected category in HomePage: $selectedCategory');
    PodcastProperties.query = selectedCategory.toLowerCase();
    category = selectedCategory;
    setState(() {});
    handleMP3();
  }

  Future<String> translateCategories({bool debug = true}) async {
    final user = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.email)
        .get();

    final userCountry = user.data()!['country'];
    PodcastProperties.country = userCountry;

    if (userCountry != 'US') {
      // if US do not translate
      PodcastProperties.mode = debug ? 'debug' : '';
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
    http.Response response =
        await http.get(Uri.parse(PodcastProperties.getURL(uid)));

    if (response.statusCode == 200) {
      PodcastProperties.mp3 = response.bodyBytes; // Load a mp3
      transcriptText = await getTranscriptText();
      setState(() {});
    } else {
      PodcastProperties.mp3 = null;
    }
  }
}
