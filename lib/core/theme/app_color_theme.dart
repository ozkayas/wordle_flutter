import 'package:flutter/material.dart';

class AppColorTheme extends ThemeExtension<AppColorTheme> {
  AppColorTheme.light()
      : boxEmpty = Color(0XFFF6F6F6),
        boxDark = Color(0XFFa9a9a8),
        boxYellow = Color(0XFFd4c151),
        boxGreen = Color(0xFF15a63b),
        keyboardEmpty = Color(0XFFe3e3e3),
        keyboardFalse = Color(0XFFa9a9a8),
        scaffoldBackground = Color(0XFFFCFDFC),
        activeText = Color(0XFFFCFDFC),
        passiveText = Color(0XFFa9a9a8),
        activeKeyboardText = Colors.white,
        passiveKeyboardText = Color(0XFF515051),
        onBackground = Colors.black;

  AppColorTheme.dark()
      : boxEmpty = Color(0XFF4e4e4f),
        boxDark = Color(0XFFa9a9a8),
        boxYellow = Color(0XFFD6BE51),
        boxGreen = Color(0xFF15a63b),
        keyboardEmpty = Color(0XFF4e4e4f),
        keyboardFalse = Color(0XFFa9a9a9),
        scaffoldBackground = Color(0XFF383838),
        activeKeyboardText = Colors.white,
        passiveKeyboardText = Colors.white,
        activeText = Color(0XFFFCFDFC),
        passiveText = Colors.grey.shade300,
        onBackground = Colors.white;

  // Current Colors used
  final Color boxEmpty;
  final Color boxDark;
  final Color boxYellow;
  final Color boxGreen;
  final Color keyboardEmpty;
  final Color keyboardFalse;
  final Color scaffoldBackground;
  final Color activeText;
  final Color activeKeyboardText;
  final Color passiveKeyboardText;
  final Color passiveText;
  final Color onBackground;

  @override
  ThemeExtension<AppColorTheme> copyWith() => AppColorTheme.light();

  @override
  ThemeExtension<AppColorTheme> lerp(
    covariant ThemeExtension<AppColorTheme>? other,
    double t,
  ) {
    if (other is! AppColorTheme) return this;
    return AppColorTheme.light();
  }
}
