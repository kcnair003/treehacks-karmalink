import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: Colors.black,
  brightness: Brightness.dark,
  backgroundColor: const Color(0xFF212121),
  dividerTheme: DividerThemeData(
    color: Colors.grey,
    thickness: 1,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.all(4),
    filled: true,
    fillColor: Colors.grey[700],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
  ),
);

final lightTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: Colors.white,
  brightness: Brightness.light,
  backgroundColor: const Color(0xFFE5E5E5),
  dividerTheme: DividerThemeData(
    color: Colors.grey,
    thickness: 1,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  shadowColor: Colors.grey,
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
