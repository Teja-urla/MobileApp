import 'package:flutter/material.dart';
import 'package:frontend/screens/loginscreen.dart';
import 'package:frontend/backend/user_details.dart';
import 'package:frontend/backend/user_projects.dart';
import 'package:frontend/screens/createUserProject.dart';
import 'package:frontend/screens/update_details.dart';

class UserProjects extends StatefulWidget {
  final String token;
  UserProjects(this.token, {super.key});

  @override
  State<UserProjects> createState() => _UserProjectsState();
}

class _UserProjectsState extends State<UserProjects> {
  User user = User();
  final UserCreatedProjects userProjects = UserCreatedProjects(); // projects created by user
  String username = '';
  List userCreatedProjectsList = [];

  @override
  void initState() {
    super.initState();
    _getUserDetails();
    _getUserProjects();
  }

  void _getUserDetails() async {
    String userDetails = await User().UserDetails(widget.token);

    if (userDetails == 'Error' || userDetails == 'Exception') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exception Happened!!!')),
      );
    } else {
      setState(() {
        username = userDetails;
      });
    }
  }

void _getUserProjects() async {
    List userCreatedProjects = await userProjects.UserProjectslist(widget.token);

    if (userCreatedProjects.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No Projects Found!!!')),
      );
    } else {
      print(userCreatedProjects);
      setState(() {
        userCreatedProjectsList = userCreatedProjects;
      });
    }
}

void _deleteProject(String token, int project_id) async {
  print("project_id" + project_id.toString());
    int statusCode = await userProjects.DeleteProject(token, project_id);
    if (statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Project Deleted Successfully')),
        // Refresh the page
      );
      _getUserProjects();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error Deleting Project')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            username + ' Projects',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          // back button
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => Loginscreen())
              );
            },
          ),
        ),
      body: Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20.0, left: 1000.0),
          width: 200,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => createUserProject(widget.token),
                ),
              );
            },
            child: const Text(
              'Create New Project',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 20, 164, 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0), // Set the border radius to 0 for rectangular shape
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
        Expanded(
          child: ListView.builder( // Using ListView.builder instead of simple for loop prevents overflow error
            itemCount: userCreatedProjectsList.length,
            itemBuilder: (context, index) {
              var i = userCreatedProjectsList[index];
              return Column(
                children: <Widget>[
                  Container(
                    child: SizedBox(
                      height: 30,
                      width: 400,
                      child: Container(
                        color: Color(0xff3187A2),
                        child: Center(
                          child: Text(
                            i[0],
                            style: TextStyle(
                              color: Colors.grey[100],
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.grey[100],
                    width: 400,
                    child: ListTile(
                      subtitle: Center(
                        child: Text(i[1]),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteProject(widget.token, i[2]);
                        },
                      ),
                      leading: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateProject(widget.token, i[2]),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ],
     ),
    );
  }
}