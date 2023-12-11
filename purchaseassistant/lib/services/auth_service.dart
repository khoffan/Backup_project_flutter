import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:purchaseassistant/services/delivers_services.dart';
import 'package:purchaseassistant/services/profile_services.dart';

import '../pages/auth/login_screen.dart';
import 'user_provider.dart';

class AuthServices {
  Future<UserCredential> SigninwithEmailandPassword(
    String? emailuser,
    String? passworduser,
  ) async {
    try {
      UserCredential userCredential;

      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailuser!, password: passworduser!);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print("ecode: ${e.code}");
      String message = "";
      if (e.code == "wrong-password" || e.code == "user-not-found") {
        message = "username หรือ password ไม่ถูกต้อง";
      }
      throw Fluttertoast.showToast(msg: message, gravity: ToastGravity.CENTER);
    }
  }

  Future<UserCredential> registerEmailandPassword(
      String? email, String? password) async {
    try {
      UserCredential userCredential;

      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'email-already-in-use') {
        message = 'มีชื่อบัญชีผู้ใช้นี้แล้ว';
      } else if (e.code == 'weak-password') {
        message = 'รหัสผ่านต้องมีความยาว 6 ตัวอักษรขึ้นไป';
      } else {
        message = e.message!;
      }
      throw Fluttertoast.showToast(msg: message, gravity: ToastGravity.CENTER);
    }
  }

  Future<void> Signoutuser(BuildContext context) async {
    String uid = await FirebaseAuth.instance.currentUser!.uid;
    if (uid != "") {
      await FirebaseAuth.instance.signOut().then((value) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const LoginScreen();
        }));
      }).catchError((e) {
        e.toString();
      });
    }
  }

  Future<void> delateUser(String uid) async {
    try {
      final currenUser = await FirebaseAuth.instance.currentUser!;
      if (currenUser != null) {
        await currenUser.delete();
      }
      if (uid != "") {
        await ProfileService().deleteProfile(uid);
        await ServiceDeliver().delateDeliver(uid);
      }
      Fluttertoast.showToast(msg: "ลบบัญชีเรียบร้อย");
    } catch (e) {
      throw Exception(e);
    }
  }
}
