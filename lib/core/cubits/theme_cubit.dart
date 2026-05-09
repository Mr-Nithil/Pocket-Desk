import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:pocket_desk/core/constants/theme_key.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final Box preferencesBox;

  ThemeCubit({required this.preferencesBox})
    : super(_loadThemeMode(preferencesBox));

  static ThemeMode _loadThemeMode(Box box) {
    final savedTheme =
        box.get(ThemeKeys.themeMode, defaultValue: ThemeKeys.light) as String;

    return savedTheme == ThemeKeys.dark ? ThemeMode.dark : ThemeMode.light;
  }

  void setLightMode() {
    preferencesBox.put(ThemeKeys.themeMode, ThemeKeys.light);
    emit(ThemeMode.light);
  }

  void setDarkMode() {
    preferencesBox.put(ThemeKeys.themeMode, ThemeKeys.dark);
    emit(ThemeMode.dark);
  }

  void toggleTheme() {
    state == ThemeMode.dark ? setLightMode() : setDarkMode();
  }
}
