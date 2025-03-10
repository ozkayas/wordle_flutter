import 'package:flutter/material.dart';

class AppColorTheme extends ThemeExtension<AppColorTheme> {
  AppColorTheme.light()
      : boxEmpty = Color(0XFFF6F6F6),
        boxDark = Color(0XFFa9a9a8),
        boxYellow = Color(0XFFd4c151),
        boxGreen = Color(0xFF15a63b),
        scaffoldBackground = Color(0XFFFCFDFC),
        activeText = Color(0XFFFCFDFC),
        passiveText = Color(0XFFa9a9a8),
        onBackground = Colors.black;

  AppColorTheme.dark()
      : boxEmpty = Color(0XFF4e4e4f),
        boxDark = Color(0XFFa9a9a8),
        boxYellow = Color(0XFFD6BE51),
        boxGreen = Color(0xFF15a63b),
        scaffoldBackground = Color(0XFF383838),
        activeText = Color(0XFFFCFDFC),
        passiveText = Colors.grey.shade300,
        onBackground = Colors.white;

  // Current Colors used
  final Color boxEmpty;
  final Color boxDark;
  final Color boxYellow;
  final Color boxGreen;
  final Color scaffoldBackground;
  final Color activeText;
  final Color passiveText;
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
