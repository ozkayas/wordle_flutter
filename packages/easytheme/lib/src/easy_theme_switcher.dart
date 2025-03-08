import 'dart:ffi';

import 'package:flutter/material.dart';
import 'easy_theme_data.dart';
import 'app_color_theme.dart';

// class ThemeCubit extends Cubit<ThemeMode> {
//   ThemeCubit() : super(ThemeMode.system);

//   void changeTheme(ThemeMode themeMode) {
//     // sl<ThemeService>().setThemeMode(themeMode);
//     emit(themeMode);
//   }
// }

class EasyThemeSwitcher extends StatefulWidget {
  const EasyThemeSwitcher({super.key, required this.child, required this.data});
  final Widget child;
  final EasyThemeData data;

  @override
  State<EasyThemeSwitcher> createState() => _EasyThemeSwitcherState();
}

class _EasyThemeSwitcherState extends State<EasyThemeSwitcher> {
  @override
  Widget build(BuildContext context) {
    return EasyThemeInheritedWidget(data: widget.data, child: widget.child);
  }
}

class EasyThemeInheritedWidget extends InheritedWidget {
  const EasyThemeInheritedWidget({
    Key? key,
    required this.data,
    this.themeMode = ThemeMode.system,
    required Widget child,
  }) : super(key: key, child: child);

  final ThemeMode themeMode;
  final EasyThemeData data;
  static EasyThemeInheritedWidget? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<EasyThemeInheritedWidget>();
  }

  @override
  bool updateShouldNotify(EasyThemeInheritedWidget oldWidget) {
    return oldWidget.themeMode != themeMode;
  }
}

ThemeData lightTheme() {
  const lightColorData = AppColorTheme.light();
  return ThemeData(
    extensions: [lightColorData],
    fontFamily: "Geologica",
    useMaterial3: true,
    scaffoldBackgroundColor: lightColorData.scaffoldBackground,
  );
}

ThemeData darkTheme() {
  const darkColorData = AppColorTheme.dark();
  return ThemeData(
    extensions: [darkColorData],
    fontFamily: "Geologica",
    useMaterial3: true,
    scaffoldBackgroundColor: darkColorData.scaffoldBackground,
  );
}
