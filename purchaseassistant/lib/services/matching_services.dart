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
      if (data != {}) {
        String cusid = data['id'] ?? "";
        String cusname = data['name'] ?? "";
        String locate = data['location'] ?? "";
        String datetime = data["date"] ?? "";
        if ((cusid, cusname, locate, datetime) != "") {
          await _firestore.collection("customerData").doc(cusid).update({
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
        await _firestore.collection("customerData").doc(uid).update({
          "cus_status": false,
        });
      } else {
        return;
      }
    } catch (e) {
      throw e.toString();
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
        await _firestore.collection("customerData").doc(docid).update({
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

  Future<void> updateDataRiderCancel(
      Map<String, dynamic> data, String docid) async {
    try {
      if (data != {}) {
        String riderid = data["id"];
        String ridername = data["name"];
        String daterider = data["date"];
        await _firestore.collection("customerData").doc(docid).update({
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
}
