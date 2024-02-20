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

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
        child: Column(
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUser.email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: CircleAvatar(
                          radius: 45.0,
                          backgroundImage: AssetImage('assets/images/8.png'),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        'Username',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          letterSpacing: 1.9,
                        ),
                      ),
                      Text(
                        userData['username'],
                        style: TextStyle(
                          fontSize: 24,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Country',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          letterSpacing: 1.9,
                        ),
                      ),
                      Text(
                        userData['country'],
                        style: TextStyle(
                          fontSize: 24,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'E-mail',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          letterSpacing: 1.9,
                        ),
                      ),
                      Text(
                        userData['email'],
                        style: TextStyle(
                          fontSize: 24,
                          color: Theme.of(context).primaryColor,
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
                height: 165), // Add some space between the button and the text

            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: ElevatedButton.icon(
                onPressed: () {
                  signUserOut();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 250, 250, 250),
                  foregroundColor: const Color.fromRGBO(241, 82, 32, 1),
                  padding: const EdgeInsets.fromLTRB(50, 12, 50, 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 1.5,
                    ),
                  ),
                ),
                icon: const Icon(Icons.logout_outlined),
                label: const Text('Log Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
