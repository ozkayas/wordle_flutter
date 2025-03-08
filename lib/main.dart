import 'package:flutter/material.dart';
import 'package:theme_mode_builder/common/theme_mode_builder_config.dart';
import 'package:theme_mode_builder/theme_mode_builder/theme_mode_builder.dart';
import 'package:wordle_flutter/core/theme/app_color_theme.dart';
import 'package:wordle_flutter/core/theme/app_text.dart';
import 'package:wordle_flutter/puzzle_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeModeBuilderConfig.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeModeBuilder(
      builder: (BuildContext context, ThemeMode themeMode) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppTxt.appTitle,
          theme: ThemeData(extensions: [AppColorTheme.light()]),
          darkTheme: ThemeData(extensions: [AppColorTheme.dark()]),
          themeMode: themeMode,
          home: const PuzzlePage(),
        );
      },
    );
  }
}
