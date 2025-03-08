import 'package:flutter/material.dart';

import 'app_color_theme.dart';

class EasyThemeData {
  //todo: take these via constructor later
  const EasyThemeData({required this.lightTheme, required this.darkTheme});


  final ThemeData lightTheme;
  final ThemeData darkTheme;
}
