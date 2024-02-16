import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:purchaseassistant/services/profile_services.dart';
import 'package:purchaseassistant/services/user_provider.dart';
import 'package:purchaseassistant/utils/formatDate.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseStorage _storage = FirebaseStorage.instance;

class ServiceDeliver {
  Future<String> uploadImagetoStorage(String name, File file) async {
    try {
      Reference ref =
          _storage.ref().child(name).child(DateTime.now().toString());
      UploadTask uploadTask = ref.putFile(file);
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
      required String imageurl,
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

        if (imageurl != "") {
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
        } else {
          print("imageurl is null");
        }
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateDeliver(
      {required String uid,
      required String Docid,
      required String title,
      required String file}) async {
    try {
      bool? status = await getStatus(uid);

      await _firestore.collection('Posts').doc(uid).set({
        'status': status,
      });

      final deliverRef = _firestore.collection('Posts').doc(uid);
      await deliverRef
          .collection('Contents')
          .doc(Docid)
          .update({'imageurl': file, 'title': title});
      print('save data success');
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

  // Stream<bool> get durationStream => checkDurationController.stream;

  Stream<bool> checkDurationDiff() async* {
    StreamController<bool> checkDurationController = StreamController<bool>();
    bool isDuration = true;
    String docsnull = "null";
    try {
      CollectionReference postref = _firestore.collection("Posts");
      QuerySnapshot postDocs = await postref.get();
      for (QueryDocumentSnapshot postDocs in postDocs.docs) {
        String postDocid = postDocs.id;
        // print(postDocid);
        CollectionReference contentRef =
            postref.doc(postDocid).collection("Contents");

        contentRef.snapshots().listen(
          (QuerySnapshot contentDocs) {
            for (QueryDocumentSnapshot contentDoc in contentDocs.docs) {
              if (contentDocs.docs.isEmpty) {
                checkDurationController.add(true);
              } else {
                Map<String, dynamic> data =
                    contentDoc.data() as Map<String, dynamic>;
                Timestamp date = data["date"];
                String day = FormatDate.date(date);
                final parseDate = DateTime.parse(day);
                String duration = data['duration'] ?? "0วัน";
                String dayDuration = duration.split("วัน")[0];

                final datediff = DateTime.now().difference(parseDate).inDays;
                if (DateTime.now().difference(parseDate).inDays <=
                        int.parse(dayDuration) &&
                    datediff <= 7) {
                  isDuration = false;
                  checkDurationController.add(isDuration);
                  // return false;
                }
                checkDurationController.add(isDuration);
              }

              // return true;
            }
          },
          onError: (dynamic error) {
            checkDurationController.addError(error);
          },
          onDone: () {
            print("get data success");
          },
        );
        yield* checkDurationController.stream;
      }
    } catch (e) {
      throw e.toString();
    }
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
