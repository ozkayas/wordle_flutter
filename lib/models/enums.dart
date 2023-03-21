import 'package:flutter/material.dart';

enum LetterState { green, yellow, light, dark }

extension LetterExtension on LetterState {
  Color get color {
    switch (this) {
      case LetterState.light:
        return Colors.blueGrey.shade300;
      // return const Color(0xffb0b0b1);
      case LetterState.dark:
        return Colors.blueGrey.shade700;

      // return const Color(0xff3a3a3c);
      case LetterState.green:
        return Colors.lightGreen;

      // return const Color(0xff538d4e);
      case LetterState.yellow:
        return Colors.yellow.shade700;

      // return const Color(0xffb69f3a);
    }
  }
}
