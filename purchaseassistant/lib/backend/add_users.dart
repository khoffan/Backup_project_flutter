import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bcrypt/bcrypt.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class UsersFirestore {
  Future<String> saveUsers(
      {required String email,
      required String password,
      required String uid,
      required bool? status}) async {
    String resp = "some Error";
    try {
      print("Attempting to save data...");
      if (email.isNotEmpty && password.isNotEmpty) {
        String hashPw = BCrypt.hashpw(password, BCrypt.gensalt());

        Map<String, dynamic> data = {
          'uid': uid,
          'email': email,
          'password': hashPw,
        };

        if (status != null) {
          await updateStatus(status, uid);
        }
        await _firestore
            .collection("Users")
            .doc(uid)
            .set(data, SetOptions(merge: true));
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

  Future<void> updateStatus(bool status, String uid) async {
    Map<String, dynamic> data = {
      'status': status,
    };

    try {
      await _firestore.collection("Users").doc(uid).update(data);
      print('Status updated in Firestore successfully!');
    } catch (e) {
      print('Error updating status in Firestore: $e');
    }
  }
}
