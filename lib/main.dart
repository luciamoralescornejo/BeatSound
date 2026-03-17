import 'package:flutter/material.dart';

void main() {
  runApp(const BeatSoundApp());
}

class BeatSoundApp extends StatelessWidget {
  const BeatSoundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BeatSound',
      home: Scaffold(
        backgroundColor: Colors.black,
        body: const Center(
          child: Text(
            'BeatSound',
            style: TextStyle(color: Colors.white, fontSize: 32),
          ),
        ),
      ),
    );
  }
}