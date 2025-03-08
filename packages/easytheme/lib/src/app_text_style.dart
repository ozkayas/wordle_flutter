import 'package:flutter/material.dart';

class AppTextStyle {
  static const String fontFamily = "Geologica";

  static TextStyle textStyle(double size, FontWeight weight) => TextStyle(
        fontFamily: fontFamily,
        fontSize: size,
        fontWeight: weight,
      );

  static final TextStyle regular10 = textStyle(10, FontWeight.normal);
  static final TextStyle regular12 = textStyle(12, FontWeight.normal);
  static final TextStyle regular14 = textStyle(14, FontWeight.normal);
  static final TextStyle regular16 = textStyle(16, FontWeight.normal);

  static final TextStyle bold14 = textStyle(14, FontWeight.bold);
  static final TextStyle bold16 = textStyle(16, FontWeight.bold);
  static final TextStyle bold18 = textStyle(18, FontWeight.bold);
  static final TextStyle bold24 = textStyle(24, FontWeight.bold);
  static final TextStyle bold22 = textStyle(22, FontWeight.bold);
}
