import 'dart:convert';

import 'package:http/http.dart' as http;

class APIMatiching {
  String baseUrl = "http://3.25.59.0/api";
  Map<String,dynamic> dataresponse = {}; 
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

      // print('Response Status Code: ${response.statusCode}');
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

  Future<Map<String, dynamic>> getResponse(Map<String, dynamic> data) async {
    if(data != {}){
       return data;
    }
    else {
      return {};
    }
  }

}
