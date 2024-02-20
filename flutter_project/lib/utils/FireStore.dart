import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreAuthService {
  final userCollection = FirebaseFirestore.instance.collection('users');

  Future<void> registerUser({
    required String username,
    required String email,
    required String country,
  }) async {
    await userCollection.doc().set({
      "username": username,
      "email": email,
      "country": country,
    });
  }
}
