import 'package:flutter/material.dart';
import 'package:frontend/screens/projectspage.dart';
import 'package:frontend/backend/upload_images_project.dart';
import 'package:file_picker/file_picker.dart';
import 'package:frontend/backend/upload_zipfile.dart';

class Projectimages extends StatefulWidget {
  final token;
  final project_name;
  final project_id;
  const Projectimages(this.project_id, this.token, this.project_name, {super.key});

  @override
  State<Projectimages> createState() => _ProjectimagesState();
}

class _ProjectimagesState extends State<Projectimages> {
  UploadImagesProject uploadImagesProject = UploadImagesProject();
  List projectImagesList = [];
  FilePickerResult? result;
  List<PlatformFile> selectedFiles = []; // platform file is used to store the selected files
  int set_number = 1;

  UploadZipfile uploadzipfile = UploadZipfile();
  FilePickerResult? result_zipfile;
  PlatformFile? selectedZipFile;



  _getProjectImages() async{
    List projectImages = await uploadImagesProject.ProjectImages(widget.token, widget.project_id, set_number);

    if (projectImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No Images Found!!!')),
      );
    } else {
      setState(() {
        projectImagesList = projectImages;
      });
    }
  }

  _deleteImage(int image_id) async {
    bool isDeleted = await uploadImagesProject.deleteImage(widget.token, image_id);
    if (isDeleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image Deleted Successfully')),
      );
      _getProjectImages();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete image')),
      );
    }
  }

train_model() async {
    if(selectedZipFile != null) {
      try {
        bool isUploaded = await uploadzipfile.upload_zipfile(widget.token, widget.project_id, result_zipfile!.files.single.path!);
        if (isUploaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Zipfile uploaded successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload zipfile')),
          );
        }
      } catch (e) {
        print('Error uploading zipfile: $e');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No zipfile selected')),
      );
    }
}

  @override
  void initState() {
    super.initState();
    _getProjectImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text(
          'Project-' + widget.project_name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xffffffff),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => UserProjects(widget.token),
              ),
            );
          },
        ),
      ),

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
                    allowMultiple: true // Set to false to allow multiple file selection
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

          Container(
            margin: const EdgeInsets.only(top: 5.0, left: 0.0), // Adjust the margin to control position
            child: Column(
              children: [
                SizedBox(
                  width: 120,
                  height: 35, // Adjusted height to make it visible
                  child: ElevatedButton(
                    onPressed: () async {
                      bool allUploadsSuccessful = true;
                      if (result != null) {
                        try{
                            for(var file in selectedFiles) {
                              allUploadsSuccessful &= await uploadImagesProject.uploadImages(widget.token, widget.project_id, file.name, file.path!);
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

                const SizedBox(height: 20),
              ],
            ),
          ),

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
            margin: const EdgeInsets.only(top: 5.0, left: 0.0),
            child: SizedBox(
              width: 120,
              height: 35,
              child: ElevatedButton(
                onPressed: () async {
                  result_zipfile = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['zip'],
                    allowMultiple: false // Only one file can be selected
                  );
                  setState(() {
                    selectedZipFile = result_zipfile!.files.single;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFFFFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0), 
                  ),
                ),
                child: const Text(
                  'Select zipfile',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),          

          const SizedBox(height: 30),
          
          if (selectedZipFile != null)
            Container(
              margin: const EdgeInsets.only(top: 5.0, left: 0.0),
              child: Text(
                'Selected Zipfile: ${selectedZipFile!.name}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          const SizedBox(height: 30),
          
          // Button to train the model
          Container(
            margin: const EdgeInsets.only(top: 5.0, left: 0.0),
            child: SizedBox(
              width: 150,
              height: 35,
              child: ElevatedButton(
                onPressed: () async {
                  train_model();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 39, 164, 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0), 
                  ),
                ),
                child: const Text(
                  'Train Model',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 80),

          Container(
             child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                      IconButton(
                      icon: Icon(Icons.arrow_left),
                      onPressed: () {
                        setState(() {
                          set_number = set_number - 1;
                        });
                        _getProjectImages();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_right),
                      onPressed: () {
                        setState(() {
                          (set_number = set_number + 1);
                        });
                        _getProjectImages();
                      },
                    ),
               ],
             ),
          ),
          
Expanded(
  child: ListView.builder(
    itemCount: projectImagesList.length,
    itemBuilder: (context, index) {
      return Container(
        margin: const EdgeInsets.only(top: 5.0, left: 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.network(
              'https://127.0.0.1:8000' + projectImagesList[index]['image_url'],
              width: 200,
              height: 200,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _deleteImage(projectImagesList[index]['id']);
              },
            ),
          ],
        ),
      );
    },
  ),
)

        ],
      ),
    );
  }
}