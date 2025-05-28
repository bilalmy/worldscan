import 'package:flutter/material.dart';
import 'package:world_scan/Screens/AdminHome.dart';
import 'package:world_scan/Screens/ResetPassword.dart';
import 'package:world_scan/Screens/SignUpScreen.dart';
import 'package:world_scan/Screens/UserHome.dart';
import 'package:world_scan/UserAuthentication/AuthUser.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthUser _authUser=AuthUser();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? emailError;
  String? passwordError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.indigo.shade700,
              Colors.indigo.shade500,
              Colors.white,
            ],
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
                  'Login to WorldScan',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),

                // Email Field
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Email',
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

                // Password Field with Eye Icon
                TextField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.lock, color: Colors.white),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    errorText: passwordError,
                  ),
                ),
                const SizedBox(height: 16),

                      GestureDetector(
                        onTap:()=>
                        {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ResetPassword(),)),
                        },
                        child: Text(
                          "Reset Password",
                          style: TextStyle(
                            color: Colors.lightBlueAccent,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                const SizedBox(height: 24),

                // Login as User Button
                ElevatedButton(
                  onPressed: () {
                    String email = emailController.text.trim();
                    String password = passwordController.text.trim();

                    setState(() {
                      emailError = null;
                      passwordError = null;
                    });

                    if (email.isEmpty) {
                      setState(() {
                        emailError = 'Please enter an email address';
                      });
                    }
                    if(emailController.text.toString()=='bilaladmin@gmail.com')
                      {
                        setState(() {
                          emailError = 'Please enter a valid email address';
                        });
                      }
                    else if (!isValidEmail(email)) {
                      setState(() {
                        emailError = 'Please enter a valid email address';
                      });
                    }

                    if (password.isEmpty) {
                      setState(() {
                        passwordError = 'Please enter a password';
                      });
                    }

                    if (emailError == null && passwordError == null) {
                      LoginUser();
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
                    "Login as User",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 12),

                // Login as Admin Button
                ElevatedButton(
                  onPressed: () {
                    String email = emailController.text.trim();
                    String password = passwordController.text.trim();

                    setState(() {
                      emailError = null;
                      passwordError = null;
                    });

                    if (email.isEmpty) {
                      setState(() {
                        emailError = 'Please enter an email address';
                      });
                    }

                    if (emailController.text!='bilaladmin@gmail.com') {
                      setState(() {
                        emailError = 'Email Not Exists';
                      });
                    }
                    else if (!isValidEmail(email)) {
                      setState(() {
                        emailError = 'Please enter a valid email address';
                      });
                    }

                    if (password.isEmpty) {
                      setState(() {
                        passwordError = 'Please enter a password';
                      });
                    }

                    if (emailError == null && passwordError == null) {
                      LoginAdmin();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 70),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Login as Admin",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),

                // Sign up link
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUpScreen(),));
                  },
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 16),
                      children: [
                        TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: "Sign Up",
                          style: TextStyle(
                            color: Colors.pink,
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


  void LoginUser() async
  {
    String? message=await _authUser.loginWithEmailAndPassword(emailController.text, passwordController.text);
    if (message != null) {
      // Show the Snackbar with the message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
    else
    {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logged in Successfully!'),
          backgroundColor: Colors.red,
        ),
      );
      if(emailController.text=='bilaladmin@gmail.com')
        {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHome(),));
        }
      else
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserHome(),));
    }
  }

  void LoginAdmin() async
  {
    String? message=await _authUser.loginWithEmailAndPassword(emailController.text, passwordController.text);
    if (message != null) {
      // Show the Snackbar with the message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
    else
    {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logged in Successfully!'),
          backgroundColor: Colors.red,
        ),
      );
      if(emailController.text=='bilaladmin@gmail.com')
      {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHome(),));
      }
      else
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserHome(),));
    }
  }
}
