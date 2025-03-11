import 'package:flutter/material.dart';
import 'app_color_theme.dart';

extension AppColorExtension on BuildContext {
  AppColorTheme get color =>
      Theme.of(this).extension<AppColorTheme>() ?? AppColorTheme.light();
}
