import 'package:anchor/chat.dart';
import 'package:anchor/home.dart';
import 'package:anchor/login.dart';
import 'package:anchor/personalization.dart';
import 'package:anchor/profilesetup.dart';
import 'package:anchor/profileview.dart';
import 'package:anchor/settings.dart';
import 'package:anchor/splash.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/splash',
    routes: {

      '/splash': (context) => SplashScreen(),
      '/login': (context) => LoginScreen(),
      '/home' : (context) => HomeScreen(),
      '/chat' : (context) => ChatPage(),
      '/settings' : (context) => SettingsPage(),
      '/personal' : (context) => VoiceBioSetupWidget(),
      '/setup' : (context) => ProfileSetupScreen(
        initialName: 'John Doe',
        initialMajor: 'Computer Science',
        initialAge: '25',
        initialGender: 'Male',
        initialInterests: ['Coding', 'Music', 'Gaming'],
      ),
      '/profileview' : (context) => ProfileViewScreen(
        name: 'John Doe',
        major: 'Computer Science',
        bio: 'A passionate developer.',
        age: '25',
        gender: 'Male',
      ),
    },
  ));
}