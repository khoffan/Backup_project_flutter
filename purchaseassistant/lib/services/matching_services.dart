import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:purchaseassistant/utils/formatDate.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class APIMatiching {
  String baseUrl = "https://e4f0-104-28-214-147.ngrok-free.app/api";
  Map<String, dynamic> dataresponse = {};
  Future<Map<String, dynamic>> sendData(
      String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      print('Response Status Code: ${response.statusCode}');
      // print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to send data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to send data: $e');
    }
  }

  Future<Map<String, dynamic>> getRiderlist(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to send data');
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Map<String, dynamic>> setResponse(Map<String, dynamic> data) async {
    if (data != {}) {
      return data;
    } else {
      return {};
    }
  }

  // sett data in firestore
  Future<void> setCustomerData(Map<String, dynamic> data) async {
    try {
      String userStatus = "";
      if (data != {}) {
        String cusid = data['id'] ?? "";
        String cusname = data['name'] ?? "";
        String locate = data['location'] ?? "";
        String datetime = data["date"] ?? "";
        if ((cusid, cusname, locate, datetime) != "") {
          DocumentSnapshot snapshot =
              await _firestore.collection("Profile").doc(cusid).get();
          if (snapshot.exists) {
            final data = snapshot.data() as Map<String, dynamic>;
            userStatus = data['statususer'] ?? "";
          }

          await _firestore.collection("Matchings").doc(cusid).set({
            "cusid": cusid,
            "cusname": cusname,
            "location": locate,
            "cus_status": true,
            "date": datetime,
            "riderid": "null",
            "ridername": "null",
            "rider_status": false,
            "dateRider": "null",
            "status": "InActive",
            "cusIsonline": userStatus
          });
        }
        print("set data success");
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateCustomerData(Map<String, dynamic> data) async {
    try {
      String userStatus = "";
      if (data != {}) {
        String cusid = data['id'] ?? "";
        String cusname = data['name'] ?? "";
        String locate = data['location'] ?? "";
        String datetime = data["date"] ?? "";
        if ((cusid, cusname, locate, datetime) != "") {
          DocumentSnapshot snapshot =
              await _firestore.collection("Profile").doc(cusid).get();
          if (snapshot.exists) {
            final data = snapshot.data() as Map<String, dynamic>;
            userStatus = data['statususer'] ?? "";
          }
          await _firestore.collection("Matchings").doc(cusid).update({
            "cusid": cusid,
            "cusname": cusname,
            "location": locate,
            "cus_status": true,
            "date": datetime,
          });
        }
        print("set data success");
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // update data
  Future<void> updateStatusCustomer(String uid) async {
    try {
      if (uid != "") {
        await _firestore.collection("Matchings").doc(uid).update({
          "cus_status": false,
        });
      } else {
        return;
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateISonline(String uid) async {
    try {
      if (uid != "") {
        String userStatus = "";
        DocumentSnapshot snapshot =
            await _firestore.collection("Profile").doc(uid).get();
        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>;
          userStatus = data['statususer'] ?? "";
        }
        await _firestore.collection("Matchings").doc(uid).update({
          "cusIsonline": userStatus,
        });
      } else {
        return;
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // update status chat customer
  Future<void> updateStatusChatCustomer(String uid) async {
    try {
      if (uid != "") {
        await _firestore.collection("Matchings").doc(uid).update({
          "status": "Active",
        });
      } else {
        return;
      }
    } on FirebaseException catch (e) {
      throw e.message.toString();
    }
  }

  // update rider status
  Future<void> updateDataRiderConfrime(
      Map<String, dynamic> data, String docid) async {
    try {
      if (data != {}) {
        String riderid = data["id"];
        String ridername = data["name"];
        String daterider = data["date"];
        await _firestore.collection("Matchings").doc(docid).update({
          "riderid": riderid,
          "ridername": ridername,
          "rider_status": true,
          "dateRider": daterider
        });
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // update status rider when closechat or cancel order
  Future<void> updateRiderData(String uid) async {
    try {
      if (uid != "") {
        await _firestore.collection("Matchings").doc(uid).update({
          "riderid": "null",
          "ridername": "null",
          "rider_status": false,
          "dateRider": "null",
        });
      } else {
        return;
      }
    } on FirebaseException catch (e) {
      print(e.code);
      print(e.message);
      throw e.toString();
    }
  }
  // get rider id

  Future<String> getRiderid(String uid) async {
    try {
      QuerySnapshot snapshot = await _firestore.collection("Matchings").get();
      if (snapshot.docs.isNotEmpty) {
        final datadoc = snapshot.docs;
        for (DocumentSnapshot data in datadoc) {
          if (data.id == uid) {
            return data["riderid"];
          }
        }
      }
      return "";
    } catch (e) {
      throw e.toString();
    }
  }

  // del document for user to rider
  Future<void> delCustomertoRider(String uid) async {
    try {
      await _firestore.collection("Matchings").doc(uid).delete();
    } catch (e) {
      throw e.toString();
    }
  }

  //get data stream document function
  Stream<Map<String, dynamic>> getData(String currid) async* {
    StreamController<Map<String, dynamic>> _snapshotController =
        StreamController<Map<String, dynamic>>();
    StreamSubscription<DocumentSnapshot>? subscription;

    try {
      DocumentReference docRef =
          await _firestore.collection("Matchings").doc(currid);

      subscription = docRef.snapshots().listen(
        (DocumentSnapshot quryData) {
          final data = quryData.data() as Map<String, dynamic>;
          Map<String, dynamic> riderDatas = {
            "riderid": data["riderid"],
            "ridername": data["ridername"],
            "rider_status": data["rider_status"],
            "dateRider": data["dateRider"]
          };
          _snapshotController.add(riderDatas);
        },
        onError: (dynamic error) {
          _snapshotController.addError(error);
        },
        onDone: () {
          // Do not close the _snapshotController here
        },
      );

      yield* _snapshotController.stream;
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } finally {
      // Close the StreamController when it's no longer needed
      _snapshotController.close();
      // Cancel the subscription when it's no longer needed
      subscription?.cancel();
    }
  }

  Stream<bool> getRiderStatus(String uid) async* {
    StreamController<bool> _streamController = StreamController<bool>();
    try {
      CollectionReference collectionRef = _firestore.collection("Matchings");

      Query query = collectionRef.where("cusid", isEqualTo: uid);

      QuerySnapshot querySnap = await query.get();

      if (querySnap.docs.isNotEmpty) {
        DocumentSnapshot docSnap = querySnap.docs.first;

        final data = docSnap.data() as Map<String, dynamic>;
        _streamController.add(data["rider_status"]);

        var subscription = docSnap.reference.snapshots().listen(
          (DocumentSnapshot quryData) {
            final data = quryData.data() as Map<String, dynamic>;
            bool newStatus = data["rider_status"];
            _streamController.add(newStatus);
          },
          onError: (dynamic error) {
            _streamController.addError(error);
          },
          onDone: () {
            _streamController.close();
          },
        );
        _streamController.done.then((_) {
          subscription.cancel();
        });
      }
      yield* _streamController.stream;
    } catch (e) {
      _streamController.addError(e.toString());
      _streamController.close();
    }
  }
  // Future<bool> getRiderStatus(String id) async {
  //   try {
  //     DocumentSnapshot snapshot =
  //         await _firestore.collection("Matchings").doc(id).get();
  //     if (snapshot.exists) {
  //       return snapshot["rider_status"];
  //     }
  //     return true;
  //   } catch (e) {
  //     throw e.toString();
  //   }
  // }
}
