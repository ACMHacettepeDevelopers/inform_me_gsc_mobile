// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

import '../audio_converter.dart';
import '../podcast_properties.dart';
import 'categories.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bottom NavBar',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 228, 83, 10),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(selectedCountry: ''),
    );
  }
}

class HomePage extends StatefulWidget {
  final String selectedCountry;

  const HomePage({super.key, this.selectedCountry = ''});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late final AudioPlayer player = AudioPlayer();
  bool isPlaying = false;
  int pageIndex = 0;
  bool buttonClicked = true;
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  final pages = [
    const Page1(), // home page
    const Page2(), // profil page
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 228, 83, 10),
      appBar: AppBar(
        title: Text(
          "Inform Me!",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: pages[pageIndex],
      bottomNavigationBar: buildMyNavBar(context),
    );
  }

  Container buildMyNavBar(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 0;
              });
            },

            // HOME PAGE BUTTON
            icon: pageIndex == 0
                ? const Icon(
                    Icons.home_filled,
                    color: Colors.white,
                    size: 40,
                  )
                : const Icon(
                    Icons.home_outlined,
                    color: Colors.white,
                    size: 40,
                  ),
          ),

          // PLAY AUDİO BUTTON
          IconButton(
            enableFeedback: false,
            onPressed: () async {
              if (buttonClicked) {
                await handlePlay();
                buttonClicked = false;
              } else {
                // fetch audio from Flask then play the audio
                if (isPlaying) {
                  player.pause();
                } else {
                  player.play();
                }
                isPlaying = !isPlaying;
                setState(() {});
              }
            },
            icon: isPlaying
                ? const Icon(
                    Icons.stop_circle,
                    color: Colors.white,
                    size: 50,
                  )
                : const Icon(
                    Icons.play_circle_outline,
                    color: Colors.white,
                    size: 50,
                  ),
          ),

          // PROFİL PAGE BUTTON
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 1;
              });
            },
            icon: pageIndex == 1
                ? const Icon(
                    Icons.account_circle,
                    color: Colors.white,
                    size: 40,
                  )
                : const Icon(
                    Icons.account_circle_outlined,
                    color: Colors.white,
                    size: 40,
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> handlePlay() async {
    if (PodcastProperties.mp3 != null) {
      final duration = await player
          .setAudioSource(AudioConverter(PodcastProperties.mp3!)); // Load a mp3
      player.play(); // Play without waiting for completion
      setState(() {
        isPlaying = true;
      });
    }
  }
}

// HOME PAGE
class Page1 extends StatefulWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  String transcriptText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Tabbar(
          onCategorySelected: (category) =>
              handleCategorySelection(category)), // Include the Tabbar widget
    );
  }

  void handleCategorySelection(String category) async {
    print('Selected category in HomePage: $category');
    PodcastProperties.query = category.toLowerCase();
  }
}

// PROFIL PAGE

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;

    // Sign user out method
    void signUserOut() {
      FirebaseAuth.instance.signOut();
    }

    return Container(
      color: const Color.fromARGB(255, 246, 243, 217),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser.email)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final userData = snapshot.data!.data() as Map<String, dynamic>;
                return Column(
                  children: [
                    Center(
                      child: Text(
                        "Logged in as\n ${currentUser.email} \ncountry is ${userData['country']}",
                        style: TextStyle(
                          color: Color.fromARGB(255, 228, 83, 10),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error${snapshot.error}'),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),

          SizedBox(
              height: 50), // Add some space between the button and the text
          Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: ElevatedButton.icon(
              onPressed: () {
                signUserOut();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color.fromRGBO(241, 82, 32, 1),
                padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: Icon(Icons.logout_outlined),
              label: Text('Log Out'),
            ),
          ),
        ],
      ),
    );
  }
}
