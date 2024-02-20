import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:loginpage/podcast_properties.dart';

class Tabbar extends StatefulWidget {
  final Function(String) onCategorySelected;

  const Tabbar({Key? key, required this.onCategorySelected}) : super(key: key);

  @override
  State<Tabbar> createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  String translations = 'Tech,Politics,Economy,Sports';
  
  Future<void> translateCategories(
      String categoriesToTranslate, String translationCountryCode,
      {bool debug = false}) async {
    final url =
        '${PodcastProperties.baseUrl}/translate_categories?categories_to_translate=$categoriesToTranslate&translation_country_code=$translationCountryCode&mode=${debug ? 'debug' : ''}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final responsetranslations = jsonResponse['translations'];
      translations = responsetranslations;
      setState(() {});
    } else {
      throw Exception('Failed to load translations');
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
                           onTap: (index) {
                            // Call the onCategorySelected function
                            widget.onCategorySelected(translations.split(',')[index]);
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
        body: const TabBarView(
          children: [
            Center(
              child: Text("Tech"),
            ),
            Center(
              child: Text("Politics"),
            ),
            Center(
              child: Text("Economy"),
            ),
            Center(
              child: Text("Sports"),
            ),
          ],
        ),
      ),
    );
  }
}
