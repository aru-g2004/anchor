import 'package:anchor/login.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart'; // Import the Google Fonts package

import 'dart:async';

class SplashScreen extends StatefulWidget {
  
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

    void initState() {
    super.initState();
    Timer(Duration(seconds: 6), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()), // Replace with your next screen
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: 
      Color(0xFF48A6A6),
        
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo and App Name
          Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Image.asset(
                  'images/anchor_logo.png', // Replace with your logo asset path
                  height: 150,
                  width: 150,
                ),
                SizedBox(height: 20),
                Text(
                  'Anchor',
                  style: GoogleFonts.dmSans( // Apply DM Sans font
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,),
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          // Carousel Slider
          CarouselSlider(
            options: CarouselOptions(
              height: 100,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 2),
              enlargeCenterPage: true,
              viewportFraction: 0.8,
            ),
            items: [
              'Drifting you toward good company...',
              'Setting sail for connection...',
              'Bringing good vibes aboard…',
            ].map((text) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    child: Center(
                      child: Text(
                        text,
                        style: GoogleFonts.dmSans( // Apply DM Sans font
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          SizedBox(height: 40),
          // Navigation Button
        ],
      ),
    );
  }
}