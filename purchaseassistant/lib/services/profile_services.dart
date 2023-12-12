import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
final User _user = _auth.currentUser!;

class ProfileService {
  Future<String?> uploadImagetoStorage(String name, File file) async {
   try {
      final ref =
          _storage.ref().child(name).child(DateTime.now().toString());
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask;
      final downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print("Error uploading image to Firebase Storage: $e");
      throw e;
    }
  }

  Future<String> saveProfile(
      {required String name,
      required String room,
      required String stdid,
      required String lname,
      required String dorm,
      required String gender,
      required String phone,
      required String file,}) async {
    String resp = "some Error";
    try {
      print("Attempting to save data...");
      if (name.isNotEmpty &&
          room.isNotEmpty &&
          lname.isNotEmpty &&
          dorm.isNotEmpty &&
          stdid.isNotEmpty &&
          gender.isNotEmpty &&
          phone.isNotEmpty) {
        
        // String? _image = await uploadImagetoStorage('/profileImage', file);
        await _firestore.collection("userProfile").doc(_user.uid ?? '').set({
          'name': name,
          'lname': lname,
          'room': room,
          'stdid': stdid,
          'dorm': dorm,
          'gender': gender,
          'phone': phone,
          'imageLink': file,
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
  Future<String> updateProfile(
      {required String name,
      required String room,
      required String stdid,
      required String lname,
      required String dorm,
      required String gender,
      required String phone,
      required String file,}) async {
    String resp = "some Error";
    try {
      print("Attempting to save data...");
      if (name.isNotEmpty &&
          room.isNotEmpty &&
          file.isNotEmpty &&
          lname.isNotEmpty &&
          dorm.isNotEmpty &&
          stdid.isNotEmpty &&
          gender.isNotEmpty &&
          phone.isNotEmpty) {
        
        await _firestore.collection("userProfile").doc(_user.uid ?? '').update({
          'name': name,
          'lname': lname,
          'room': room,
          'stdid': stdid,
          'dorm': dorm,
          'gender': gender,
          'phone': phone,
          'imageLink': file,
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
    try{
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore.collection('userProfile').doc(_user.uid ?? '').get();
      return snapshot;
    } catch (e){
      throw e.toString();
    }
  }

  Future<void> deleteProfile(String uid) async {
    try {
      await _firestore.collection('userProfile').doc(uid).delete();
    } catch (e) {
      throw e.toString();
    }
  }
}
