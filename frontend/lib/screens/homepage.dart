import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/screens/loginscreen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:frontend/backend/upload_image.dart';
import 'package:frontend/backend/user_details.dart';

class HomePage extends StatefulWidget {
  final String token;
  HomePage(this.token, {super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Images images = Images();
  final User user = User();

  String choosen_image_name = 'No Image Selected';
  FilePickerResult? result;
  List<PlatformFile> selectedFiles = [];
  
  String username = '';

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  void _getUserDetails() async {
    String userDetails = await User().UserDetails(widget.token);

    if (userDetails == 'Error' || userDetails == 'Exception') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exception Happened!!!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Welcome $userDetails')),
      );
      setState(() {
        username = userDetails;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome $username',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        // back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Loginscreen()),
            );
          },
        ),
      ),
      backgroundColor: Color(0xffE8EDF0),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.only(top: 5.0, left: 0.0),
            child: const Text(
              'Upload Image',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.only(top: 5.0, left: 0.0),
            child: SizedBox(
              width: 120,
              height: 35,
              child: ElevatedButton(
                onPressed: () async {
                  result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['jpg', 'jpeg', 'png'],
                    allowMultiple: true
                  );

                  if (result != null) {
                    setState(() {
                      selectedFiles = result!.files;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFFFFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0), 
                  ),
                ),
                child: const Text(
                  'Select Image',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
          for (var file in selectedFiles)
            Container(
              margin: const EdgeInsets.only(top: 5.0, left: 0.0),
              child: Text(
                'Selected Image: ${file.name}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          const SizedBox(height: 50), // Adjusted height to make it visible
          
          Container(
            margin: const EdgeInsets.only(top: 5.0, left: 0.0), // Adjust the margin to control position
            child: SizedBox(
              width: 120,
              height: 35, // Adjusted height to make it visible
              child: ElevatedButton(
                onPressed: () async {
                  bool allUploadsSuccessful = true;
                  if (result != null) {
                    try{
                        for(var file in selectedFiles) {
                          allUploadsSuccessful &= await images.uploadImage(file.name, file.path!);
                        }
                    } catch (e) {
                      allUploadsSuccessful = false;
                      print('Error uploading image: $e');
                    }
                    if(allUploadsSuccessful){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('All Images uploaded successfully')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to upload image')),
                      );
                    }

                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('No image selected')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1434A4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0), // Set the border radius to 0 for rectangular shape
                  ),
                ),
                child: const Text(
                  'Upload',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
