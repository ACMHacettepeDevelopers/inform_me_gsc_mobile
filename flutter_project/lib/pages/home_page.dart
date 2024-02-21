import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../utils/audio_converter.dart';
import '../podcast_properties.dart';
import 'news_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
    const NewsPage(), // home page
    const ProfilePage(), // profil page
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                if (player.audioSource != null) {
                  if (isPlaying) {
                    player.pause();
                  } else {
                    player.play();
                  }
                  isPlaying = !isPlaying;
                  setState(() {});
                }
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
              setState(() => pageIndex = 1);
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
      await player
          .setAudioSource(AudioConverter(PodcastProperties.mp3!)); // Load a mp3
      player.play(); // Play without waiting for completion
      setState(() {
        isPlaying = true;
      });
    }
  }
}
