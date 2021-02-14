import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:treehacks2021/constants/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(lightTheme) {
    _init();
  }

  var _instance = SharedPreferences.getInstance();

  void _init() async {
    var prefs = await _instance;
    String selectedTheme = prefs.getString('selected_theme');
    if (selectedTheme == 'dark') {
      emit(darkTheme);
    }
  }

  void toggle() async {
    var prefs = await _instance;
    if (state == lightTheme) {
      prefs.setString('selected_theme', 'light');
      emit(darkTheme);
    } else {
      prefs.setString('selected_theme', 'dark');
      emit(lightTheme);
    }
  }
}
