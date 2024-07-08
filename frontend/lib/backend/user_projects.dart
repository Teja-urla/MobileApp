import 'dart:convert'; // for jsonDecode

import 'package:http/http.dart' as http;

class UserCreatedProjects{
  Future<List>  UserProjectslist(String token) async{
    try {
      String baseURL = "http://127.0.0.1:8000/projects/";
      var response = await http.get(
        Uri.parse(baseURL),
        headers: {
          'Token' : '$token',
        },
      );
      if(response.statusCode == 200){
        var user_details = jsonDecode(response.body);
        print(user_details);
        List user_projects = [];
        // put the project_name and project_description in a list
        for (var i in user_details){
          user_projects.add([i['project_name'], i['project_description']]);
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

}