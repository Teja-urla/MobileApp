import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/backend/upload_project.dart';
import 'package:frontend/screens/projectspage.dart';

class Newproject extends StatefulWidget {
  final String token;
  const Newproject(this.token, {super.key});

  @override
  State<Newproject> createState() => _NewprojectState();
}

class _NewprojectState extends State<Newproject> {
  UploadProject project_upload = UploadProject();
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _projectDescriptionController = TextEditingController();

void CreateProject() async{
    String projectName = _projectNameController.text;
    String projectDescription = _projectDescriptionController.text;
    if(projectName.isEmpty || projectDescription.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all the fields')),
      );
      return;
    }
    int statusCode = await project_upload.uploadProject(widget.token, projectName, projectDescription);
    if(statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Project Created Successfully')),
      );
    } 
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error Creating Project')),
      );
    }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Project',
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
              MaterialPageRoute(
                builder: (context) => UserProjects(widget.token),
              ),
            );
          },
        ),
      ),

      body: Column(
         children: [
            // Project Name
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _projectNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Project Name',
                ),
              ),
            ),
            // Project Description
            
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _projectDescriptionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Project Description',
                ),
              ),
            ),
            

            // Create Project Button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  CreateProject();
                },
                child: Text('Create Project'),
              ),
            ),
         ],
      ),
    );
  }
}