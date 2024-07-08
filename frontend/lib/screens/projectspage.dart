import 'package:flutter/material.dart';
import 'package:frontend/screens/loginscreen.dart';
import 'package:frontend/backend/user_details.dart';
import 'package:frontend/backend/user_projects.dart';

class UserProjects extends StatefulWidget {
  final String token;
  UserProjects(this.token, {super.key});

  @override
  State<UserProjects> createState() => _UserProjectsState();
}

class _UserProjectsState extends State<UserProjects> {
  User user = User();
  final UserCreatedProjects userProjects = UserCreatedProjects();
  String username = '';
  List ProjectsList = [];

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
    List userProjectsList = await userProjects.UserProjectslist(widget.token);

    if (userProjectsList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No Projects Found!!!')),
      );
    } else {
      print(userProjectsList);
      setState(() {
        ProjectsList = userProjectsList;
      });
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

        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              for (var i in ProjectsList) // display the project_name and project_description in cards
                Card(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title:Text('Project Name: ' + i[0],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )
                        )
                          ,
                        subtitle: Text(i[1]),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        )
    );
  }
}