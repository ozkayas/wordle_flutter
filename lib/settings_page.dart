import 'package:flutter/material.dart';
import 'package:wordle_flutter/core/theme/app_color_ext.dart';
import 'package:wordle_flutter/core/theme/app_text.dart';
import 'package:wordle_flutter/widgets/theme_switch.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        title: const Text(AppTxt.settings),
        backgroundColor: context.color.scaffoldBackground,
        foregroundColor: context.color.onBackground,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Text(
              AppTxt.theme,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: context.color.onBackground),
            ),
            const SizedBox(height: 16),
            const ThemeSwitch(),
            // Add more settings here as needed
          ],
        ),
      ),
    );
  }
}
