// File: main.dart
import 'package:flutter/material.dart';
import 'start_screen.dart'; // We will create this file next

void main() {
  runApp(UnimasArNavigationApp());
}

class UnimasArNavigationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UNIMAS AR Navigation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StartScreen(), // The first screen of our app
    );
  }
}