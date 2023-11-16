import 'dart:convert';
import 'package:http/http.dart' as http;

class APIMatiching {
  String baseUrl = 'https://b190-1-47-7-195.ngrok-free.app/api';

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
      print('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to send data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to send data: $e');
    }
  }
}
