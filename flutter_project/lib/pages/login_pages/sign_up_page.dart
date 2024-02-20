// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/model/select_status_model.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:loginpage/utils/FireStore.dart';
import 'package:loginpage/firebase/google_service.dart';
import 'package:loginpage/pages/home_page.dart';
import 'country_picker.dart'; // Import the CountryPicker widget

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

void showRegistrationSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Registration Successful'),
        content: Center(
          child: Text(
            'Congratulations! You have successfully registered.',
            textAlign: TextAlign.center, // Align text to center
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

class _SignUpPageState extends State<SignUpPage> {
  String selectedCountry = "";
  String address = "";
  String countryAlp2 = "";
  final usernameController = TextEditingController();
  final eMailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final countryController = TextEditingController();

  // Function to handle country selection
  void handleCountryChanged(String country) {
    setState(() {
      selectedCountry = country;
    });
    print("Selected Country: $selectedCountry"); // Print selected country
  }

  void signUpFunct() async {
    if (passwordController.text == passwordConfirmController.text &&
        usernameController.text.isNotEmpty &&
        passwordController.text.trim().length >= 6) {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: eMailController.text,
        password: passwordController.text,
      );
      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.email)
          .set(
        {
          'username': usernameController.text,
          'email': eMailController.text,
          'country': countryAlp2,
        },
      );

      // pop up ekle
      showRegistrationSuccessDialog(context);
    } else if (passwordController.text.trim().length < 6) {
      showSomeDialog(
          'There is an error', 'password length must be at least 6', context);
    } else {
      showSomeDialog('There is an error', 'Try again', context);
    }
  }

  void showSomeDialog(String title, String content, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/8.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 70,
                ),
                Text(
                  'Not a member ?',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Register now !',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(50, 3, 50, 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.orange),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'username',
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(50, 3, 50, 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.orange),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: TextField(
                        controller: eMailController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'e-mail',
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(50, 3, 50, 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.orange),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'password',
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(50, 3, 50, 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.orange),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: TextField(
                        controller: passwordConfirmController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 're-type password',
                        ),
                      ),
                    ),
                  ),
                ),

                // country picker
                CountryPicker(
                  onCountryChanged: (value, alph2) {
                    setState(() {
                      selectedCountry = value;
                      print("sign up page - selcted country: $selectedCountry");
                      countryAlp2 = alph2;
                    });
                  },
                ),

                Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      signUpFunct();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color.fromRGBO(241, 82, 32, 1),
                      padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: Icon(Icons.create_sharp),
                    label: Text('Register'),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 3, 0, 0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      GoogleServiceClass().gSignInFunc();
                    },
                    icon: Image.asset('assets/images/googlelogo.png'),
                    label: Text('Sign Up with Google.'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: const Color.fromRGBO(241, 82, 32, 1),
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'A member? ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/loginpage');
                      },
                      child: Text(
                        'Log In now.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: const Color.fromRGBO(241, 82, 32, 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
