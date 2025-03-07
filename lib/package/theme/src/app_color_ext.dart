import 'package:flutter/material.dart';

import 'app_color_data.dart';

extension AppColorExtension on BuildContext {
  AppColorData get color =>
      Theme.of(this).extension<AppColorData>() ?? const AppColorData.light();
}
