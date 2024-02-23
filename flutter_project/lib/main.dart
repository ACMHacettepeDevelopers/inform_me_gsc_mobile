import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loginpage/pages/home_page.dart';
import 'firebase/firebase_options.dart';
import 'pages/login_pages/auth_service.dart';
import 'pages/login_pages/login_page.dart';

import 'pages/login_pages/sign_up_page.dart';
import 'pages/login_pages/starter_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inform Me!',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 228, 83, 10),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      debugShowCheckedModeBanner: false,
      home: AuthService(),
      routes: {
        '/homepage': (context) => HomePage(),
        '/loginpage': (context) => LogInPage(),
        '/signuppage': (context) => SignUpPage(),
      },
    );
  }
}
