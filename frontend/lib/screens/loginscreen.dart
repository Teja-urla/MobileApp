import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/backend/user_details.dart'; // Update with your correct import path
import 'package:frontend/screens/projectspage.dart';

final storage = FlutterSecureStorage();

class AppState {
  static String? token;

  static void setToken(String newToken) {
    token = newToken;
  }

  static String? getToken() {
    return token;
  }
}


class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  User user = User();
  AppState appState = AppState();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';


void _login() async {
  String username = _usernameController.text;
  String password = _passwordController.text;

  try {
    String tokenReturned = await user.login(username, password); // Assuming this method returns the JWT token

    if (tokenReturned.isNotEmpty) {
      AppState.setToken(tokenReturned);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserProjects(AppState.getToken()!),
        ),
      );
    } else {
      setState(() {
        _errorMessage = 'Invalid username or password';
      });
    }
  } catch (e) {
    print('Login error: $e');
    setState(() {
      _errorMessage = 'Error during login';
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
          color: Color.fromARGB(255, 243, 242, 241),
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
