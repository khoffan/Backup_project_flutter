import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:purchaseassistant/utils/formatDate.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class APIMatiching {
  String baseUrl = "https://cdbe-2a09-bac1-6f00-98-00-1f1-1d2.ngrok-free.app/api";
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
  Future<void> setMatchingResult(
      String cusid, String riderid, String cusname, String ridername) async {
    try {
      if ((cusname, ridername, cusid, riderid) != "") {
        List<String> ids = [cusid, riderid];
        ids.sort();
        String matchid = ids.join("_");
        Timestamp timestamp = Timestamp.now();
        String datetime = FormatDate(timestamp);
        await _firestore.collection("matchingResult").doc(matchid).set({
          "cusid": cusid,
          "riderid": riderid,
          "cusname": cusname,
          "ridername": ridername,
          "date": datetime
        });
      }
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  Future<Map<String, dynamic>> getMatchingresult(String cusid, String riderid) async {
    try {
      List<String> ids = [cusid,riderid];
      ids.sort();
      String match_id = ids.join("_");


      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection("matchingResult").doc(match_id).get();
      if (snapshot.exists) {
        return snapshot.data() ?? {};
      } else {
        return {};
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
