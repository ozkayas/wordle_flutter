import 'package:flutter/material.dart';

class AppColorData extends ThemeExtension<AppColorData> {
  const AppColorData.light()
      : charBox = const Color(0xFFE30613),
        charBoxText = const Color(0xFF12AF17),
        keyboard = const Color(0xFF99A1AE),
        keyboardText = const Color(0xFFD3D4D3),
        scaffoldBackground = const Color(0xFFF2F2F2),
        appOrange = const Color(0xFFFEB541),
        appYellow = const Color(0xFFFFEB3B);

  const AppColorData.dark()
      : charBox = const Color(0xFFE30613),
        charBoxText = const Color(0xFF12AF17),
        keyboard = const Color(0xFF99A1AE),
        keyboardText = const Color(0xFFD3D4D3),
        scaffoldBackground = const Color(0xFFF2F2F2),
        appOrange = const Color(0xFFFEB541),
        appYellow = const Color(0xFFFFEB3B);

  // Current Colors used
  final Color charBox;
  final Color charBoxText;
  final Color keyboard;
  final Color keyboardText;
  final Color scaffoldBackground;
  final Color appOrange;
  final Color appYellow;

  @override
  ThemeExtension<AppColorData> copyWith() {
    return const AppColorData.light();
  }

  @override
  ThemeExtension<AppColorData> lerp(
    covariant ThemeExtension<AppColorData>? other,
    double t,
  ) {
    if (other is! AppColorData) return this;
    return const AppColorData.light();
  }
}
