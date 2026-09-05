import 'dart:async';
import 'package:flutter/material.dart';
import 'main.dart'; // Import HomePage

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait for 3 seconds then navigate to HomePage
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Show your logo here
        child: Image.asset(
          'assets/images/logo.png', // Make sure this file exists
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}
