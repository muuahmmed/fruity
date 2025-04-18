import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error creating user: $e');
      return null;
    }
  }

  // Compare this snippet from lib/Register/services/firebase_service.dart:
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Attempt to sign in the user
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Return the signed-in user
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      switch (e.code) {
        case 'user-not-found':
          print('Error: No user found for that email.');
          break;
        case 'wrong-password':
          print('Error: The email address or the password is not valid.');
          break;
        case 'invalid-email':
          print('Error: The email address or the password is not valid.');
          break;
        case 'user-disabled':
          print('Error: The user account has been disabled.');
          break;
        default:
          print('Error signing in with email and password: ${e.message}');
      }
      return null;
    } catch (e) {
      // Handle any other errors
      print('Unexpected error signing in: $e');
      return null;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return null;

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

      // Sign in with the credential
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);

      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }
}
