import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/login_screen.dart';
import 'add_users.dart';




class AuthUsers {
  final FirebaseAuth _firebaseauth = FirebaseAuth.instance;


  Future<UserCredential> signUpWithEmailpass(
      String email, String password, bool? status) async {
    try {
      UserCredential userCredential =
          await _firebaseauth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await UsersFirestore().saveUsers(
        uid: userCredential.user!.uid,

        email: email,
        password: password,

        status: status
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<UserCredential> signInwithEmailpassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential =
          await _firebaseauth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> signOut(BuildContext context) async {
    _firebaseauth.signOut().then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  void updateStatus(bool status, String uid) async {
    await UsersFirestore().updateStatus(status,uid);
  }
}
