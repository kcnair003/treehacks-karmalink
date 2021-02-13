import 'package:flutter/material.dart';
import '../constants/Themes.dart';

class ThemeNotifier extends ChangeNotifier {
  bool switchUse = false;
  ThemeData selectedTheme = lightTheme;
  toggle() {
    if (selectedTheme == lightTheme) {
      selectedTheme = darkTheme;
      switchUse = true;
    } else {
      selectedTheme = lightTheme;
      switchUse = false;
    }
    notifyListeners();
  }
}
