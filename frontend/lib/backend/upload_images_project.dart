import 'dart:convert'; // for jsonDecode
import 'package:http/http.dart' as http;
import 'dart:io';

class UploadImagesProject {
  
  Future<List> ProjectImages(String token, int project_id, int set_number) async {
    final String baseURL = "https://127.0.0.1:8000/project-images/";
    try {
      print("PROJECT ID : **** " + project_id.toString());
      var baseURL = "https://127.0.0.1:8000/project-images/";
      var response = await http.post(
        Uri.parse(baseURL),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Token': '$token',
          // 'set_num': set_number.toString(),
        },
        body: jsonEncode(
          {
            'project_id': project_id,
            'set_num': set_number,
          },
        ),
      );
      print(set_number);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);       
        List projectImages = [];
        for (var i in data) {
          // add image_name and image_url to projectImages
          projectImages.add({
            'id': i['id'],
            'image_name': i['image_name'],
            'image_url': i['image_url'],
          });
        }
        return projectImages;
      } else {
        return [];
      }
      
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<bool> uploadImages(String token, int project_id, String image_name, String image_url) async {
    try{
       final baseURL = "https://127.0.0.1:8000/project-images/upload/";
       var file = File(image_url);
       var request = http.MultipartRequest('POST', Uri.parse(baseURL));
       
        request.files.add(await http.MultipartFile.fromPath('image_url', file.path, filename:image_name));
        request.fields['image_name'] = image_name;
        request.fields['project_id'] = project_id.toString();
        
        request.headers['Content-Type'] = 'application/json; charset=UTF-8';
        request.headers['Token'] = token;
        var response = await request.send();
        if(response.statusCode == 201){
          print('Image uploaded successfully *** ');
          return true;
        }
        else{
          var responseData = await response.stream.bytesToString();
          print('Failed to upload image *** Status code: ${response.statusCode}, Response: $responseData');
          return false;
        }
    }
    catch(e){
      print(e);
      return false;
    }
  }

  Future<bool> deleteImage(String token, int image_id) async {
    try {
      final baseURL = "https://127.0.0.1:8000/project-images/";
      var response = await http.delete(
        Uri.parse(baseURL),
        headers:{
          'Content-Type': 'application/json; charset=UTF-8',
          'Token': token,
        },
        body: jsonEncode({
          'id' : image_id,
        })
      );

      if(response.statusCode == 200){
        return true;
      }
      else{
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}