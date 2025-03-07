import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  void changeTheme(ThemeMode themeMode) {
    // sl<ThemeService>().setThemeMode(themeMode);
    emit(themeMode);
  }
}
