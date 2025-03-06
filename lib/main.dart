import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordle_flutter/app_text.dart';
import 'package:wordle_flutter/puzzle_page.dart';

import 'features/keyboard/keyboard_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppTxt.appTitle,
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: BlocProvider<KeyboardCubit>(
        create: (_) => KeyboardCubit(),
        child: const PuzzlePage(),
      ),
    );
  }
}
