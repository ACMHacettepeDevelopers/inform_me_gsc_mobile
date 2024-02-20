// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginpage/firebase/google_service.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final eMailController = TextEditingController();
  final passwordController = TextEditingController();

  void signInFunct() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: eMailController.text,
        password: passwordController.text,
      );
      showSomeDialog(
          'Sign In Successful', 'You have successfully signed in.', context);
    } on FirebaseAuthException catch (e) {
      showSomeDialog('There is an error',
          'E-mail or password incorrect, try again.', context);
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

  void errorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.amber,
          title: Center(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
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
        )),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 80,
                ),
                Image.asset(
                  'assets/images/login_transp.png',
                  height: 200,
                  width: 200,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                ),
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    // font ekle
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(43, 30, 43, 5),
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
                  padding: EdgeInsets.fromLTRB(43, 3, 43, 5),
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
                Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      signInFunct();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color.fromRGBO(241, 82, 32, 1),
                      padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: Icon(Icons.login_outlined),
                    label: Text('Log In'),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 3, 0, 0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      GoogleServiceClass().gSignInFunc();
                    },
                    icon: Image.asset('assets/images/googlelogo.png'),
                    label: Text('Log In with Google'),
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
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      //padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 180),
                    ),
                    Text(
                      'Not a member? ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/signuppage');
                      },
                      child: Text(
                        'Register now.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: const Color.fromRGBO(241, 82, 32, 1),
                        ),
                      ),
                    )
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
