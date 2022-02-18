import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordle_flutter/puzzle_page.dart';

import 'cubit/table_cubit.dart';
import 'keyboard/cubit/keyboard_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TableCubit(),
      child: MaterialApp(
        title: 'Wordley',
        theme: ThemeData(
          primarySwatch: Colors.lightGreen,
        ),
        home: BlocProvider<KeyboardCubit>(
          create: (_) => KeyboardCubit(),
          child: const PuzzlePage(),
        ),
      ),
    );
  }
}
