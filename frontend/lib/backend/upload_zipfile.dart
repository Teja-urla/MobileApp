import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UploadZipfile {
  Future<bool> upload_zipfile(String token, int project_id, String zipfile_url) async {
      try {
        final baseURL = "https://127.0.0.1:8000/yolo-models/";
        var file = File(zipfile_url);
        var request = http.MultipartRequest('POST', Uri.parse(baseURL));
        request.files.add(await http.MultipartFile.fromPath('zip_file', file.path, filename:zipfile_url));
        request.fields['project_id'] = project_id.toString();

        request.headers['Content-Type'] = 'application/json; charset=UTF-8';
        request.headers['Token'] = token;

        var response = await request.send();
        if (response.statusCode == 200) {
          return true;
        } else {
          return false;
        }
      }
      catch(e) {
        print(e);
        return false;
      }
  }
}