import 'dart:convert'; // for jsonEncode
import 'package:http/http.dart' as http;

class UploadProject{
   Future<int> uploadProject(String token, String project_name, String project_description) async{
    try {
      String baseURL = "http://127.0.0.1:8000/projects/";
      var response = await http.post(
         Uri.parse(baseURL),
         headers: {
            'Content-Type': 'application/json; charset=UTF-8',
           'Token': '$token', // Include the token in the Authorization header
         },
          body: jsonEncode(<String, String>{
            'project_name': project_name,
            'project_description': project_description,
          }),
      );
          return response.statusCode;
    } catch (e) {
      print(e);
      return 500;
    }
  }
}