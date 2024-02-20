import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../podcast_properties.dart';

class Tabbar extends StatefulWidget {
  final Function(String) onCategorySelected;

  const Tabbar({Key? key, required this.onCategorySelected}) : super(key: key);

  @override
  State<Tabbar> createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  String transcriptText = '';
  String translations = 'Tech,Politics,Economy,Sports';

  Future<void> translateCategories(
      String categoriesToTranslate, String translationCountryCode,
      {bool debug = true}) async {
    PodcastProperties.mode = debug ? 'debug' : '';
    PodcastProperties.query = categoriesToTranslate;
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 56),
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
                            translateCategories(
                                translations as String, userData['country']);
                          } else {
                            translations = 'Tech,Politicis,Economy,Sports';
                          }
                        }
                        List<Tab> tabs = [];
                        for (final String t in translations.split(',')) {
                          tabs.add(Tab(
                            text: t,
                          ));
                        }
                        return TabBar(
                          tabs: tabs,
                          onTap: (index) async {
                            // Call the onCategorySelected function
                            widget.onCategorySelected(
                                translations.split(',')[index]);
                            await handleMP3();
                            setState(() {});
                          },
                        );
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
        body: TabBarView(
          children: [
            for (final category in translations.split(','))
              Center(
                child: Column(
                  children: [
                    Expanded(
                        child: ListView(children: [
                      Text(category),
                      FutureBuilder<String>(
                          future: handleMP3(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(snapshot.data!);
                            }
                            return const Text("Loading...");
                          })
                    ]))
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  Future<String> getTranscriptText() async {
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
