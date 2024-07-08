import 'dart:convert'; // for jsonDecode

import 'package:http/http.dart' as http;

class User {

  Future<String> login(String username, String password) async {
    try {
      String baseURL = "http://127.0.0.1:8000/users/login/"; 
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
      print(response.body);
      if (response.statusCode == 200) {
        var token_returned = jsonDecode(response.body)['access_token'];
        return token_returned;
      } else {
        return '';
      }
    } catch (e) {
      print(e);
      return '';
    }
  }

  Future<String> UserDetails(String token) async{
  try {
    String baseURL = "http://127.0.0.1:8000/users/";
    var response = await http.get(
      Uri.parse(baseURL),
      headers: {
        'Token': '$token', // Include the token in the Authorization header
      },
    );

    if (response.statusCode == 200) {
      var user_details = jsonDecode(response.body);
      return user_details['username'];
    } else {
      return 'Error';
    }
  } catch (e) {
    print(e);
    return 'Exception';
  }
  }
}

