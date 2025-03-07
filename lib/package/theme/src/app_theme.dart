import 'package:flutter/material.dart';

import 'app_color_data.dart';

class EasyTheme {
  ThemeData lightTheme() {
    const lightColorData = AppColorData.light();
    return ThemeData(
      extensions: [lightColorData],
      fontFamily: "Geologica",
      useMaterial3: true,
      scaffoldBackgroundColor: lightColorData.scaffoldBackground,
    );
  }

  ThemeData darkTheme() {
    const darkColorData = AppColorData.dark();
    return ThemeData(
      extensions: [darkColorData],
      fontFamily: "Geologica",
      useMaterial3: true,
      scaffoldBackgroundColor: darkColorData.scaffoldBackground,
    );
  }
}
