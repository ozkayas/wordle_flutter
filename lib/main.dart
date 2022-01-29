import 'package:flutter/material.dart';
import 'package:wordle_flutter/puzzle_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wordley',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: const PuzzlePage(),
    );
  }
}
