import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:purchaseassistant/services/user_provider.dart';
// import 'package:flutter/material.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
final User _user = _auth.currentUser!;

class ProfileService {
  Future<String?> uploadImagetoStorage(String name, File file) async {
    try {
      final ref = _storage.ref().child(name).child(DateTime.now().toString());
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask;
      final downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> saveProfile(Map<String, dynamic> profile) async {
    String resp = "some Error";
    try {
      print("Attempting to save data...");
      if (profile != {}) {
        String name = profile['name'] ?? '';
        String lname = profile['lname'] ?? '';
        String room = profile['room'] ?? '';
        String stdid = profile['stdId'] ?? '';
        String dorm = profile['dorm'] ?? '';
        String gender = profile['gender'] ?? '';
        String phone = profile['phone'] ?? '';
        String file = profile['image'] ?? '';
        // String? _image = await uploadImagetoStorage('/profileImage', file);
        await _firestore.collection("Profile").doc(_user.uid).set({
          'name': name,
          'lname': lname,
          'room': room,
          'stdid': stdid,
          'dorm': dorm,
          'gender': gender,
          'phone': phone,
          'imageLink': file,
          'statususer': "",
          'active': "0",
          'role': "customer"
        });
        print("Data saved successfully!");
        resp = "Success";
      } else {
        print("name or bio is empty");
      }
    } catch (e) {
      resp = e.toString();
    }

    return resp;
  }

  Future<String> updateProfile(Map<String, dynamic> profile) async {
    String resp = "some Error";
    try {
      print("Attempting to save data...");
      if (profile != {}) {
        String name = profile['name'] ?? '';
        String lname = profile['lname'] ?? '';
        String room = profile['room'] ?? '';
        String stdid = profile['stdId'] ?? '';
        String dorm = profile['dorm'] ?? '';
        String gender = profile['gender'] ?? '';
        String phone = profile['phone'] ?? '';
        String file = profile['image'] ?? '';
        await _firestore.collection("Profile").doc(_user.uid).update({
          'name': name,
          'lname': lname,
          'room': room,
          'stdid': stdid,
          'dorm': dorm,
          'gender': gender,
          'phone': phone,
          'imageLink': file,
          'statususer': "",
        });
        print("Data saved successfully!");
        resp = "Success";
      } else {
        print("name or bio is empty");
      }
    } catch (e) {
      resp = e.toString();
    }

    return resp;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDataProfile() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('Profile').doc(_user.uid ?? '').get();
      return snapshot;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> deleteProfile(String uid) async {
    try {
      await _firestore.collection('Profile').doc(uid).delete();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> getImage(String uid) async {
    try {
      if (uid == "" || uid.isEmpty) {
        // Return a default value or handle the case where uid is empty or null
        return "https://cdn-icons-png.flaticon.com/512/3135/3135715.png";
      }

      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection("Profile").doc(uid).get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return data["imageLink"] as String;
      } else {
        // Return a default value if there's no image link
        return "https://cdn-icons-png.flaticon.com/512/3135/3135715.png";
      }
    } catch (e) {
      // Instead of throwing an error, you might want to log it or handle it differently
      print("Error fetching image link: $e");
      // Return a default value in case of an error
      return "https://cdn-icons-png.flaticon.com/512/3135/3135715.png";
    }
  }

  Future<void> updateRole(String uid, String role) async {
    try {
      if (uid != "" && role != "") {
        await _firestore.collection("Profile").doc(uid).update({"role": role});
      } else {
        print("update fail");
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateStatusUser(String uid) async {
    String userStatus = "";
    try {
      if (uid != "") {
        bool? loginStatus = await UserLogin.getLogin();
        if (loginStatus == true) {
          userStatus = "online";
        } else {
          userStatus = "offline";
        }
        await _firestore
            .collection("Profile")
            .doc(uid)
            .update({"statususer": userStatus});
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
