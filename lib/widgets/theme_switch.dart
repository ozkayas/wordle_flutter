// ignore_for_file: library_private_types_in_public_api

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:theme_mode_builder/theme_mode_builder.dart';
import 'package:wordle_flutter/core/theme/app_color_ext.dart';

class ThemeSwitch extends StatefulWidget {
  const ThemeSwitch({super.key});

  @override
  State<ThemeSwitch> createState() => _ThemeSwitchState();
}

class _ThemeSwitchState extends State<ThemeSwitch> {
  ThemeMode themeMode = ThemeMode.system;
  @override
  void initState() {
    super.initState();
    themeMode = ThemeModeBuilderConfig.getThemeMode();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: AnimatedToggleSwitch<ThemeMode>.rolling(
        animationDuration: Durations.medium1,
        current: themeMode,
        values: [ThemeMode.system, ThemeMode.light, ThemeMode.dark],
        onChanged: (mode) {
          switch (mode) {
            case ThemeMode.system:
              ThemeModeBuilderConfig.setSystem();
              setState(() => themeMode = ThemeMode.system);
            case ThemeMode.light:
              ThemeModeBuilderConfig.setLight();
              setState(() => themeMode = ThemeMode.light);
            case ThemeMode.dark:
              ThemeModeBuilderConfig.setDark();
              setState(() => themeMode = ThemeMode.dark);
          }
        },
        borderWidth: 1.0,
        style: ToggleStyle(backgroundColor: Colors.white),
        iconBuilder: (ThemeMode mode, _) {
          switch (mode) {
            case ThemeMode.system:
              return const Icon(Icons.brightness_auto);
            case ThemeMode.light:
              return const Icon(Icons.light_mode);
            case ThemeMode.dark:
              return const Icon(Icons.dark_mode);
          }
        },
      ),
    );
  }
}
