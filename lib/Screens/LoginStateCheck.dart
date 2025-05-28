import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:world_scan/Screens/AdminHome.dart';
import 'package:world_scan/Screens/LoginScreen.dart';
import 'package:world_scan/Screens/ResetPassword.dart';
import 'package:world_scan/Screens/SignUpScreen.dart';
import 'package:world_scan/Screens/UserHome.dart';
import 'package:world_scan/UserAuthentication/AuthUser.dart';

class LoginStateCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder:
    (context, snapshot){
      try {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(),);
        }
        if (snapshot.hasError) {
          return Center(child: Text("System Error Occured !"));
        }
        else {
          if (snapshot.data == null) {
            return LoginScreen();
          }
          else {
           return
               UserHome();
          }
        }
      }
      catch(e)
      {
        return
            Center(child: Text('System Error'),);
      }
    });
  }

}
