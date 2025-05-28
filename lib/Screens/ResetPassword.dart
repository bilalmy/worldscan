import 'package:flutter/material.dart';
import 'package:world_scan/Screens/LoginScreen.dart';
import 'package:world_scan/UserAuthentication/AuthUser.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPassword> {
  final AuthUser _authUser = AuthUser();
  TextEditingController emailController = TextEditingController();
  String? emailError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.blue.shade600, Colors.purple.shade400, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.language, size: 80, color: Colors.white),
                const SizedBox(height: 16),
                const Text(
                  'Reset Your Password',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),

                // Email Field for Password Reset
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Enter Your Email',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.email, color: Colors.white),
                    errorText: emailError,
                  ),
                ),
                const SizedBox(height: 16),

                // Reset Password Button
                ElevatedButton(
                  onPressed: () {
                    String email = emailController.text.trim();

                    setState(() {
                      emailError = null;
                    });

                    if (email.isEmpty) {
                      setState(() {
                        emailError = 'Please enter your email address';
                      });
                    } else if (!isValidEmail(email)) {
                      setState(() {
                        emailError = 'Please enter a valid email address';
                      });
                    }

                    if (emailError == null) {
                      resetPassword();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 80),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Send Reset Email",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),

                // Back to Login Button
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => LoginScreen(),));
                  },
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 16),
                      children: [
                        TextSpan(
                          text: "Remember your password? ",
                          style: TextStyle(color: Colors.white),
                        ),
                        TextSpan(
                          text: "Login",
                          style: TextStyle(
                            color: Colors.lightBlueAccent,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  void resetPassword() async {
    String email = emailController.text.trim();
    String? message = await _authUser.sendPasswordResetEmail(email);

    if (message == null) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password reset email sent! Please check your inbox.'),
          backgroundColor: Colors.green,
        ),
      );

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
