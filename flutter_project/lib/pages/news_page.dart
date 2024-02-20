// HOME PAGE
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../podcast_properties.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  String transcriptText = '';
  String translations = 'Tech,Politics,Economy,Sports';
  String category = 'Tech';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 56),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(currentUser.email)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final userData =
                            snapshot.data!.data() as Map<String, dynamic>;
                        if (userData['country'] != 'England') {
                          translateCategories(userData['country']);
                        } else {
                          translations = 'Tech,Politicis,Economy,Sports';
                        }
                      }
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
                    }),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: newsWidget(),
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
      onTap: () async {
        handleCategorySelection(c);
        await handleMP3();
        setState(() {});
      },
    );
  }

  Widget newsWidget() {
    return ListView(
      children: [
        Text(category),
        FutureBuilder<String>(
            future: handleMP3(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!);
              }
              return const Text("Loading...");
            })
      ],
    );
  }

  void handleCategorySelection(String selectedCategory) async {
    print('Selected category in HomePage: $selectedCategory');
    PodcastProperties.query = selectedCategory.toLowerCase();
    category = selectedCategory;
    setState(() {});
  }

  Future<void> translateCategories(String translationCountryCode,
      {bool debug = true}) async {
    PodcastProperties.mode = debug ? 'debug' : '';
    PodcastProperties.query = translations;
    final response =
        await http.get(Uri.parse(PodcastProperties.getCategoryTranslateURL()));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final responsetranslations = jsonResponse['translations'];
      translations = responsetranslations;
      setState(() {});
    } else {
      //throw Exception('Failed to load translations');
      print("ERRORRR");
    }
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

  Future<String> handleMP3() async {
    if (category.isEmpty) return '';
    final uid = FirebaseAuth.instance.currentUser?.uid;
    http.Response response =
        await http.get(Uri.parse(PodcastProperties.getURL(uid)));

    if (response.statusCode == 200) {
      PodcastProperties.mp3 = response.bodyBytes; // Load a mp3
      return await getTranscriptText();
    } else {
      PodcastProperties.mp3 = null;
      return '';
    }
  }
}
