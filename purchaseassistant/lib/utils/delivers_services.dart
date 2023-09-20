import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:purchaseassistant/utils/profile_services.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseStorage _storage = FirebaseStorage.instance;

class ServiceDeliver {
  Future<String> uploadImagetoStorage(String name, Uint8List file) async {
    try {
      Reference ref =
          _storage.ref().child(name).child(DateTime.now().toString());
      UploadTask uploadTask = ref.putData(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print("Error uploading image to Firebase Storage: $e");
      throw e;
    }
  }

  Future<void> saveDeliver(
      {required String uid,
      required String title,
      required Uint8List file}) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> getProfilesnapshot =
          await AddProfile().getDataProfile();


      if (getProfilesnapshot.exists) {
        Map<String, dynamic> data =
            getProfilesnapshot.data() as Map<String, dynamic>;

        bool? status = await getStatus(uid);
        String name = data['name'] ?? '';
        String lname = data['lname'] ?? '';
        String stdid = data['stdid'] ?? '';

        Timestamp timestamp = Timestamp.now();

        String imageurl = await uploadImagetoStorage('deliverImage', file);
        await _firestore.collection('deliverPost').doc(uid).set({
          'status': status,
        });

        final deliverRef = _firestore.collection('deliverPost').doc(uid);
        await deliverRef.collection('deliverContent').add({
          'name': name,
          'lastname': lname,
          'stdid': stdid,
          'imageurl': imageurl,
          'title': title,
          'date': timestamp
        });
        print('save data success');
      }
    } catch (e) {
      throw e.toString();
    }
  }
  Future<void> updateDeliver(
      {required String uid,
      required String Docid,
      required String title,
      required Uint8List file}) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> getProfilesnapshot =
          await AddProfile().getDataProfile();


      if (getProfilesnapshot.exists) {
        Map<String, dynamic> data =
            getProfilesnapshot.data() as Map<String, dynamic>;

        bool? status = await getStatus(uid);
        String name = data['name'] ?? '';
        String lname = data['lname'] ?? '';
        String stdid = data['stdid'] ?? '';

        Timestamp timestamp = Timestamp.now();

        String imageurl = await uploadImagetoStorage('deliverImage', file);
        await _firestore.collection('deliverPost').doc(uid).set({
          'status': status,
        });

        final deliverRef = _firestore.collection('deliverPost').doc(uid);
        await deliverRef.collection('deliverContent').doc(Docid).update({
          'imageurl': imageurl,
          'title': title,
          'date': timestamp
        });
        print('save data success');
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> removeDeliverer({required String uid, required String docid}) async {
    try{
      await _firestore.collection('deliverPost').doc(uid).collection('deliverContent').doc(docid).delete();
    } catch (e) {

    }
  }



  


  Future<void> updateStatus(bool status, String uid) async {
    try {
      if (uid != '' && status != null) {
        
        await _firestore.collection('deliverPost').doc(uid).update({
          'status': status,
        });
      }
      print("update success");
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> setStatus(bool status, String uid) async{
    try {
      if (uid != '' && status != '') {
        Timestamp timestamp = Timestamp.now();
        await _firestore.collection('deliverPost').doc(uid).set({
          'status': status,
          'date': timestamp
        });
      }
      print("update success");
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool?> getStatus(String uid) async {
    try {
      if (uid != '') {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await _firestore.collection('deliverPost').doc(uid).get();
        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data()!;
          return data['status'] as bool;
        }
        return null;
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
