import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'CameraScreen.dart';
import 'Camera2.dart';
  // Get a list of available cameras.

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) => Center(
              child: ElevatedButton(
                child: Text("Go"),
                onPressed: () => 
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CameraScreen()),
              ),
            ),
      ),
    ));
  }
}
