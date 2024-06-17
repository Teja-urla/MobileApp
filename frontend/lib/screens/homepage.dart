import 'package:flutter/material.dart';
import 'package:frontend/screens/loginscreen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HOME PAGE',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        // back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
      Navigator.pushReplacement( context,
        MaterialPageRoute(builder: (context) => Loginscreen()), // Replace with your home page widget
      );
          },
        ),
      ),
      body: const Center(
        child: Text('Welcome to the home page!')
      ),
    );
  }
}