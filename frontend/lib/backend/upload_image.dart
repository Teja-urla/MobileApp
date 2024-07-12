import 'dart:convert'; // for jsonDecode
import 'package:http/http.dart' as http;
import 'dart:io';

class Images {
  final String baseURL = "https://127.0.0.1:8000/images/";

  Future<bool> uploadImage(String imageName, String imageURL) async {
    try {
      var file = File(imageURL);
      var request = http.MultipartRequest('POST', Uri.parse(baseURL));
      
      // Add the file to the request
      request.files.add(await http.MultipartFile.fromPath(
        'image_url',
        file.path,
        filename: imageName,
      ));

      request.fields['image_name'] = imageName;

      var response = await request.send();

      if (response.statusCode == 201) {
        print('Image uploaded successfully *** ');
        return true;
      } else {
        var responseData = await response.stream.bytesToString();
        print('Failed to upload image *** Status code: ${response.statusCode}, Response: $responseData');
        return false;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return false;
    }
  }

}
