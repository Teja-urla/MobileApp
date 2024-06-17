import 'dart:convert'; // for jsonDecode

import 'package:http/http.dart' as http;

class Student {
  
  Future<List<dynamic>> getStudentDetails() async {
    String baseURL = "http://127.0.0.1:8000/students/";
    var response = await http.get(Uri.parse(baseURL));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      return data;
    } else {
      throw Exception('Failed to load student details');
    }
  }

  Future<bool> sendStudentDetails(String username, String password) async {
    try {
      String baseURL = "http://127.0.0.1:8000/students/validate/"; 
      var response = await http.post(
        Uri.parse(baseURL),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );
      if (response.statusCode == 200) {
        // Assuming the backend responds with status 200 for valid credentials
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}

