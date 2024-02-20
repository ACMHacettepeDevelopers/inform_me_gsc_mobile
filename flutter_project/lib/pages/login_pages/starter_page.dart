import 'package:flutter/material.dart';

class StarterPage extends StatefulWidget {
  const StarterPage({super.key});

  @override
  State<StarterPage> createState() => _StarterPageState();
}

class _StarterPageState extends State<StarterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/12.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Column(
          children: [
            SizedBox(
              height: 520,
            ),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.login,
                ),
                label: Text('Log In'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.yellow[800],
                  padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Not a member? ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Register now.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[800],
                    ),
                  ),
                )
              ],
            )
          ],
        )
      ],
    ));
  }
}
