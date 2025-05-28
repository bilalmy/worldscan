import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:world_scan/Screens/AdminHome.dart';
import 'package:world_scan/Screens/ResetPassword.dart';
import 'package:world_scan/Screens/SignUpScreen.dart';
import 'package:world_scan/Screens/SplashScreen.dart';
import 'package:world_scan/Screens/UserHome.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:SplashScreen(), // Or SplashScreen() if you want to start there
    );
  }
}