import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  primarySwatch: Colors.green,
  primaryColor: Colors.red,
  brightness: Brightness.dark,
  backgroundColor: const Color(0xFF212121),
  dividerColor: Colors.black12,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  dividerTheme: DividerThemeData(
    color: Colors.grey,
    thickness: 1,
  ),
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.all(4),
    filled: true,
    fillColor: Colors.grey[700],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
  ),
  // toggleButtonsTheme: ToggleButtonsThemeData(),
  toggleableActiveColor: Colors.blue,
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.blue,
  ),
);

final lightTheme = ThemeData(
  primarySwatch: Colors.green,
  primaryColor: Colors.blue,
  brightness: Brightness.light,
  backgroundColor: const Color(0xFFE5E5E5),
  dividerColor: Colors.white54,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  dividerTheme: DividerThemeData(
    color: Colors.grey,
    thickness: 1,
  ),
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.all(4),
    filled: true,
    fillColor: Colors.grey[300],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
  ),
);
