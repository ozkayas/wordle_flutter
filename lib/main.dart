import 'package:flutter/material.dart';
import 'package:wordle_flutter/app_text.dart';
import 'package:wordle_flutter/puzzle_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppTxt.appTitle,
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: const PuzzlePage(),
    );
  }
}
