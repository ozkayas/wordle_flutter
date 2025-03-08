import 'package:flutter/material.dart';

class AppColorTheme extends ThemeExtension<AppColorTheme> {
  AppColorTheme.light()
      : boxDefault = Colors.blueGrey.shade300,
        boxDark = Colors.blueGrey.shade700,
        boxYellow = Colors.yellow.shade700,
        boxGreen = Colors.lightGreen,
        scaffoldBackground = Colors.white,
        text = Colors.white,
        onBackground = Colors.black;

  AppColorTheme.dark()
      : boxDefault = Colors.blueGrey.shade300,
        boxDark = Colors.blueGrey.shade700,
        boxYellow = const Color.fromARGB(255, 209, 160, 37),
        boxGreen = const Color.fromARGB(255, 143, 182, 98),
        scaffoldBackground = const Color.fromARGB(255, 19, 19, 19),
        text = Colors.black,
        onBackground = Colors.white;

  // Current Colors used
  final Color boxDefault;
  final Color boxDark;
  final Color boxYellow;
  final Color boxGreen;
  final Color scaffoldBackground;
  final Color text;
  final Color onBackground;

  @override
  ThemeExtension<AppColorTheme> copyWith() {
    return AppColorTheme.light();
  }

  @override
  ThemeExtension<AppColorTheme> lerp(
    covariant ThemeExtension<AppColorTheme>? other,
    double t,
  ) {
    if (other is! AppColorTheme) return this;
    return AppColorTheme.light();
  }
}
