import 'package:flutter/material.dart';
import 'package:frontend/backend/student_details.dart';
import 'package:frontend/screens/homepage.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  Student student = Student();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  void _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    var student_details = await student.getStudentDetails();
    print(student_details);
    bool isValid1 = await student.sendStudentDetails(username, password);

    if (isValid1) {
      // Navigate to home page
      Navigator.pushReplacement( context,
        MaterialPageRoute(builder: (context) => HomePage()), // Replace with your home page widget
      );
    } else {
      // Display error message
      setState(() {
        _errorMessage = 'Invalid username or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LOGIN PAGE',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, // Change the color of the text to white
          ),
        ),
        // add color to app bar
        backgroundColor: Color(0xff00004B),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          color: const Color(0xFFE5E4E2),
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: Center(
                  child: Image.asset('assets/login_image.png'),
                ),
              ),
              Expanded(
                flex: 3,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 400, // Set the width of the username text box
                        child: TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            hintText: 'Username',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 50), // Empty space between text fields
                      SizedBox(
                        width: 400, // Set the width of the password text box
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      if (_errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            _errorMessage,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                // Add a rectangular button to submit the login details
                child: Center(
                  child: SizedBox(
                    width: 400,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 148, 0, 211),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0), // Set the border radius to 0 for rectangular shape
                        ),
                      ),
                      child: const Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
