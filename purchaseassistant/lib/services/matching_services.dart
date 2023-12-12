import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:purchaseassistant/utils/formatDate.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class APIMatiching {
  String baseUrl = "https://14db-2a09-bac1-6f00-98-00-1f1-1a1.ngrok-free.app/api";
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
      String cusid, String riderid, String cusname, String ridername, String locate) async {
    try {
      if ((cusname, ridername, cusid, riderid, locate) != "") {
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
          "location": locate,
          "date": datetime
        });
        print("set data success");
      }
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  Future<List<Map<String, dynamic>>> getMatchingresult() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firestore.collection("matchingResult").get();

      List<Map<String, dynamic>> result = [];

      for(QueryDocumentSnapshot<Map<String, dynamic>> doc in querySnapshot.docs){
        List<String> extracid = doc.id.split('_');
        Map<String, dynamic> data = doc.data();
        String doccusid = extracid[0];
        String docriderid = extracid[1];
        if(data["cusid"] != doccusid || data["riderid"] != docriderid){
          String doccusid = extracid[1];
          String docriderid = extracid[0];
          Map<String, dynamic> resultid = {
            "cusid": doccusid,
            "riderid": docriderid,
          };
          result.add(resultid);
        }
        else {
          Map<String, dynamic> resultid = {
            "cusid": doccusid,
            "riderid": docriderid,
          };
          result.add(resultid);
        }
      }
      return result;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Map<String,dynamic>> getMatckingData(String cusid, String riderid) async {
    try{
      List<String> ids = [cusid,riderid];
      ids.sort();
      String match_id = ids.join("_");

      DocumentSnapshot snapshot = await _firestore.collection("matchingResult").doc(match_id).get();
      if(snapshot.exists){
        Map<String, dynamic> data = snapshot.data() as Map<String,dynamic>;
        return data;
      }
      return {};
    } catch(e){
      throw e.toString();
    }
  }
}
