import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// PROFIL PAGE

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
                        style: const TextStyle(
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

          const SizedBox(
              height: 50), // Add some space between the button and the text
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: ElevatedButton.icon(
              onPressed: () {
                signUserOut();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color.fromRGBO(241, 82, 32, 1),
                padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.logout_outlined),
              label: const Text('Log Out'),
            ),
          ),
        ],
      ),
    );
  }
}
