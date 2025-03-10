import 'package:flutter/material.dart';
import 'package:wordle_flutter/core/theme/app_color_ext.dart';

enum LetterState { green, yellow, light, dark }

extension LetterExtension on LetterState {
  Color color(BuildContext context) {
    switch (this) {
      case LetterState.light:
        return context.color.keyboardEmpty;
      case LetterState.dark:
        return context.color.keyboardFalse;
      case LetterState.green:
        return context.color.boxGreen;
      case LetterState.yellow:
        return context.color.boxYellow;
    }
  }
}
