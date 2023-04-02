import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordle_flutter/puzzle_page.dart';

import 'features/keyboard/keyboard_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  // test test
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wordley',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: BlocProvider<KeyboardCubit>(
        create: (_) => KeyboardCubit(),
        child: PuzzlePage(),
      ),
    );
  }
}
