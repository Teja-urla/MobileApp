import 'dart:convert'; // for jsonDecode

import 'package:http/http.dart' as http;

class UserCreatedProjects{
  Future<List>  UserProjectslist(String token) async{
    try {
      String baseURL = "https://127.0.0.1:8000/projects/"; // Secure communication
      var response = await http.get(
        Uri.parse(baseURL),
        headers: {
          'Token' : '$token',
        },
      );
      if(response.statusCode == 200){
        var user_details = jsonDecode(response.body);
        // print(user_details);
        List user_projects = [];
        // put the project_name and project_description in a list
        for (var i in user_details){
          user_projects.add([i['project_name'], i['project_description'], i['id']]);
        }

        return user_projects;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<int> DeleteProject(String token, int project_id) async{
    try {
      String baseURL = "https://127.0.0.1:8000/projects/";   // Secure communication
      var response = await http.delete(
        Uri.parse(baseURL),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Token' : '$token',
        },
        body: 
          jsonEncode(<String, int>{
            'id': project_id,
          }),
      );
      return response.statusCode;
    } 
    catch (e) {
      print(e);
      return 500;
    }
  }

  Future<int> UpdateProject(String token, int project_id, String project_name, String project_desc) async {
    try{
      String baseURL = "https://127.0.0.1:8000/projects/";  // Secure communication
      var response = await http.put(
        Uri.parse(baseURL),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Token' : '$token',
        },
        body: 
          jsonEncode(<String, dynamic>{
            'id': project_id,
            'project_name': project_name,
            'project_description': project_desc,
          }),
      );

      return response.statusCode;
    } catch(e) {
      print(e);
      return 500;
    }
  }
}