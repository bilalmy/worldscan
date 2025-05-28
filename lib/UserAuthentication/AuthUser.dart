
import 'package:firebase_auth/firebase_auth.dart';

class AuthUser
{
FirebaseAuth _auth=FirebaseAuth.instance;

Future<String?> signupWithEmailAndPassword(String email, String password) async {
try {
await _auth.createUserWithEmailAndPassword(email: email, password: password);
return null; // null means success
} on FirebaseAuthException catch (e) {
if (e.code == 'email-already-in-use') {
return 'Email already exists';
} else if (e.code == 'weak-password') {
return 'Password should be at least 6 characters';
} else {
return 'Signup failed: ${e.message}';
}
} catch (e) {
return 'Unexpected error: $e';
}
}

// Login Method
Future<String?> loginWithEmailAndPassword(String email, String password) async {
  try {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    return null; // Success
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      return 'No user found for that email';
    } else if (e.code == 'wrong-password') {
      return 'Incorrect password';
    } else {
      return 'Login failed: ${e.message}';
    }
  } catch (e) {
    return 'Unexpected error: $e';
  }
}

  // Logout Method
  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<String?> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null; // Success, return null for no error
    } on FirebaseAuthException catch (e) {
      // Handle specific FirebaseAuthException errors
      if (e.code == 'user-not-found') {
        return 'No user found with this email address';
      } else if (e.code == 'invalid-email') {
        return 'The email address is not valid';
      } else {
        return 'An error occurred. Please try again later';
      }
    } catch (e) {
      // Handle any other errors
      return 'An unexpected error occurred';
    }
  }
}

