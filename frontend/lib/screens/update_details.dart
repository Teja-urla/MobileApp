import 'package:flutter/material.dart';
import 'package:frontend/backend/upload_project.dart';
import 'package:frontend/backend/user_details.dart';
import 'package:frontend/backend/user_projects.dart';
import 'package:frontend/screens/projectspage.dart';

class UpdateProject extends StatefulWidget {
  final String token;
  final int project_id;
  const UpdateProject(this.token, this.project_id, {super.key});

  @override
  State<UpdateProject> createState() => _UpdateProjectState();
}

class _UpdateProjectState extends State<UpdateProject> {
  UserCreatedProjects userProjects = UserCreatedProjects();
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _projectDescriptionController = TextEditingController();

  void _updateProject(String token) async {
    String projectName = _projectNameController.text;
    String projectDescription = _projectDescriptionController.text;
    if (projectName.isEmpty || projectDescription.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all the fields')),
      );
      return;
    }
    int statusCode = await userProjects.UpdateProject(widget.token, widget.project_id, projectName, projectDescription);
    if (statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Project Editted Successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error Editting Project')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Project',
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
      body: Center(
        child: Container(
          margin: EdgeInsets.all(5.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  width: 500,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  color: Colors.grey[300],
                  child: Text (
                    'Update Project',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
        
                SizedBox(height: 16.0),
        
                SizedBox(
                  width: 500,
                    child : TextField(
                      controller: _projectNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Project Name',
                      ),
                    ),
                ),
        
                SizedBox(height: 15.0),
                SizedBox(
                  width: 500,
                    child: TextField(
                      controller: _projectDescriptionController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Project Description',
                      ),
                    ),
                ),
        
                SizedBox(height: 15.0),
                Container(
                  width: 150,
                  height: 50,
                  child: ElevatedButton (
                    onPressed: () {
                      _updateProject(widget.token);
                    },
                    child: Text(
                      'Update',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 20, 164, 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
