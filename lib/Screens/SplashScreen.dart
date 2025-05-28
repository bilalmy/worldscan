import 'dart:async';
import 'package:flutter/material.dart';
import 'package:world_scan/Screens/LoginStateCheck.dart';
import 'LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait for 3 seconds, then navigate to the login screen
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginStateCheck ()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.indigo.shade700,
                Colors.deepPurple.shade700,
                Colors.blue.shade600,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                    Icons.language,
                    size: 120,
                    color: Colors.white
                ), // Globe icon to represent "WorldScan"
                const SizedBox(height: 20),
                const Text(
                  'WorldScan',
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Discover the World at a Glance',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70
                  ),
                ),
                const SizedBox(height: 30),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )  // White loading spinner
              ],
            ),
          ),
        ),
      ),
    );
  }
}
