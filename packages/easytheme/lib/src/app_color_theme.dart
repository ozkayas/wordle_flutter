import 'package:flutter/material.dart';

class AppColorTheme extends ThemeExtension<AppColorTheme> {
  const AppColorTheme.light()
      : boxDefault = const Color(0xFFE30613),
        boxDark = const Color(0xFF12AF17),
        boxYellow = const Color(0xFF99A1AE),
        boxGreen = const Color(0xFFD3D4D3),
        scaffoldBackground = const Color(0xFFF2F2F2),
        text = const Color(0xFFFEB541);

  const AppColorTheme.dark()
      : boxDefault = const Color(0xFFE30613),
        boxDark = const Color(0xFF12AF17),
        boxYellow = const Color(0xFF99A1AE),
        boxGreen = const Color(0xFFD3D4D3),
        scaffoldBackground = const Color(0xFFF2F2F2),
        text = const Color(0xFFFEB541);

  // Current Colors used
  final Color boxDefault;
  final Color boxDark;
  final Color boxYellow;
  final Color boxGreen;
  final Color scaffoldBackground;
  final Color text;

  @override
  ThemeExtension<AppColorTheme> copyWith() {
    return const AppColorTheme.light();
  }

  @override
  ThemeExtension<AppColorTheme> lerp(
    covariant ThemeExtension<AppColorTheme>? other,
    double t,
  ) {
    if (other is! AppColorTheme) return this;
    return const AppColorTheme.light();
  }
}
