// splash_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'main.dart'; // Import your main screen or home screen file

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Add a delay to simulate a loading process
    Timer(Duration(seconds: 2), () {
      // Navigate to the main screen after the delay
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => RecipeList()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your app logo or branding image goes here
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                'https://as2.ftcdn.net/v2/jpg/02/75/77/59/1000_F_275775971_xM0xqMUXgdCQuo0he9em32qu7OiVcx1P.jpg', // Replace with the actual path to your logo
                height: 100.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'COOK BOOK',
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
