import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF48A6A6), // Same teal background as splash screen
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'images/anchor_logo.png', // Updated logo path
                height: 150,
                width: 150,
              ),
              SizedBox(height: 20),
              // App name
              Text(
                'Anchor',
                style: GoogleFonts.dmSans(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 40),
              // Username TextField
              SizedBox(
                width: 300,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'University Email',
                    labelStyle: GoogleFonts.dmSans(color: Colors.white70),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                  style: GoogleFonts.dmSans(color: Colors.white),
                ),
              ),
              SizedBox(height: 40),
              // Sign in with SSO Button
              ElevatedButton(
                onPressed: () {
                  // Handle sign in with SSO action
                  Navigator.pushReplacementNamed(context, '/setup'); // Navigate to home screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xFF48A6A6),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Sign in with SSO',
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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