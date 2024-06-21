import 'package:flutter/material.dart';
import 'package:frontend/screens/loginscreen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:frontend/backend/upload_image.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Images images = Images();
  String folderPath = 'No Folder Selected';
  List<String> selectedFiles = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'File Upload',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
      backgroundColor: const Color(0xffE8EDF0),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.only(top: 5.0, left: 0.0),
            child: const Text(
              'Upload Folder',
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
                  String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

                  if (selectedDirectory != null) {
                    setState(() {
                      folderPath = selectedDirectory;
                      selectedFiles = Directory(selectedDirectory)
                          .listSync()
                          .whereType<File>()
                          .map((file) => file.path.split('/').last)
                          .where((fileName) => ['jpg', 'jpeg', 'png'].contains(fileName.split('.').last.toLowerCase()))
                          .toList();
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
                  'Select Folder',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
          Container(
            margin: const EdgeInsets.only(top: 5.0, left: 0.0),
            child: Column(
              children: selectedFiles.map((file) {
                return Text(
                  'Selected File: $file',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 50),
          Container(
            margin: const EdgeInsets.only(top: 5.0, left: 0.0),
            child: SizedBox(
              width: 120,
              height: 35,
              child: ElevatedButton(
                onPressed: () async {
                  if (folderPath != 'No Folder Selected') {
                    await images.uploadFolder(folderPath);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Folder upload completed')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No folder selected')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1434A4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
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
