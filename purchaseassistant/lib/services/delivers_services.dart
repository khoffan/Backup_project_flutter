import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:purchaseassistant/services/profile_services.dart';
import 'package:purchaseassistant/services/user_provider.dart';

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

  Future<void> saveDeliverPosts(
      {required String uid,
      required String title,
      required Uint8List file,
      required String duration}) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> getProfilesnapshot =
          await ProfileService().getDataProfile(uid);

      if (getProfilesnapshot.exists) {
        Map<String, dynamic> data =
            getProfilesnapshot.data() as Map<String, dynamic>;

        bool? status = await getStatus(uid);
        String name = data['name'] ?? '';
        String lname = data['lname'] ?? '';
        String stdid = data['stdid'] ?? '';

        Timestamp timestamp = Timestamp.now();

        String imageurl = await uploadImagetoStorage('deliverImage', file);
        await _firestore.collection('Posts').doc(uid).update({
          'status': status,
        });

        final deliverRef = _firestore.collection('Posts').doc(uid);
        await deliverRef.collection('Contents').add({
          'name': name,
          'lastname': lname,
          'stdid': stdid,
          'imageurl': imageurl,
          'title': title,
          'date': timestamp,
          'duration': duration
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
          await ProfileService().getDataProfile(uid);

      if (getProfilesnapshot.exists) {
        Map<String, dynamic> data =
            getProfilesnapshot.data() as Map<String, dynamic>;

        bool? status = await getStatus(uid);

        Timestamp timestamp = Timestamp.now();

        String imageurl = await uploadImagetoStorage('deliverImage', file);
        await _firestore.collection('Posts').doc(uid).set({
          'status': status,
        });

        final deliverRef = _firestore.collection('Posts').doc(uid);
        await deliverRef
            .collection('Contents')
            .doc(Docid)
            .update({'imageurl': imageurl, 'title': title, 'date': timestamp});
        print('save data success');
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> setData(String uid) async {
    try {
      String name = "";
      String stdid = "";
      String userstatus = "";
      String locatePost = "";

      if (uid != '') {
        DocumentSnapshot<Map<String, dynamic>> getProfilesnapshot =
            await _firestore.collection('Profile').doc(uid).get();
        bool? loginstatus = await UserLogin.getLogin();
        String? getWork = await getWorkingsts(uid);

        DocumentSnapshot<Map<String, dynamic>> getLocateioninPost =
            await _firestore.collection("Posts").doc(uid).get();

        if (getLocateioninPost.exists) {
          Map<String, dynamic> data = getLocateioninPost.data()!;
          locatePost = data['locattion'];
        }

        if (getProfilesnapshot.exists) {
          Map<String, dynamic> data = getProfilesnapshot.data()!;
          name = data['name'];
          stdid = data['stdid'];
        }
        if (loginstatus == true) {
          userstatus = "online";
          Timestamp timestamp = Timestamp.now();
          await _firestore.collection('Posts').doc(uid).set({
            'stdid': stdid,
            'name': name,
            'locattion': locatePost,
            'role': false,
            'status': userstatus,
            'statuswork': "unActive",
            'date': timestamp
          });
        }
        Timestamp timestamp = Timestamp.now();
        await _firestore.collection('Posts').doc(uid).set({
          'stdid': stdid,
          'name': name,
          'locattion': "null",
          'role': false,
          'status': userstatus,
          'statuswork': "unActive",
          'date': timestamp
        });
      }
      print("update success");
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> removeDeliverer(
      {required String uid, required String docid}) async {
    try {
      await _firestore
          .collection('Posts')
          .doc(uid)
          .collection('Contents')
          .doc(docid)
          .delete();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateStatus(bool status, String uid, String locate) async {
    try {
      if (uid != '' && status != '') {
        await _firestore.collection('Posts').doc(uid).update({
          'role': status,
          'locattion': locate,
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
            await _firestore.collection('Posts').doc(uid).get();
        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data()!;
          return data['role'] as bool;
        }
        return null;
      }
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  Future<void> updateUser(String uid, bool? userstatus) async {
    try {
      if (uid != "") {
        if (userstatus == false) {
          await _firestore
              .collection('Posts')
              .doc(uid)
              .update({'status': "offline"});
        } else {
          await _firestore
              .collection('Posts')
              .doc(uid)
              .update({'status': "online"});
        }
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateWorking(String uid, bool status) async {
    try {
      if (uid != "" && status == true) {
        await _firestore
            .collection('Posts')
            .doc(uid)
            .update({'statuswork': "Active"});
      }
      if (uid != "" && status == false) {
        await _firestore
            .collection('Posts')
            .doc(uid)
            .update({'statuswork': "DeActive"});
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String?> getWorkingsts(String uid) async {
    try {
      if (uid != "") {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await _firestore.collection('Posts').doc(uid).get();
        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data()!;
          return data['statuswork'] as String;
        }
        return null;
      }
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  Future<void> delateDeliver(String uid) async {
    try {
      await _firestore.collection('Posts').doc(uid).delete();
    } catch (e) {
      throw e.toString();
    }
  }

  Stream<QuerySnapshot> streamPosts() {
    try {
      return _firestore.collection("Posts").snapshots();
    } catch (e) {
      // Handle the exception or log the error if needed
      print(e.toString());

      // Throw an exception to ensure that the function doesn't complete normally
      throw Exception("An error occurred while fetching the stream of posts");
    }
  }
}
