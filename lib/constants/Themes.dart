import 'package:flutter/material.dart';

final darkTheme = ThemeData(
    primarySwatch: Colors.green,
    primaryColor: Colors.red,
    brightness: Brightness.dark,
    backgroundColor: const Color(0xFF212121),
    dividerColor: Colors.black12,
    visualDensity: VisualDensity.adaptivePlatformDensity);

final lightTheme = ThemeData(
    primarySwatch: Colors.green,
    primaryColor: Colors.blue,
    brightness: Brightness.light,
    backgroundColor: const Color(0xFFE5E5E5),
    dividerColor: Colors.white54,
    visualDensity: VisualDensity.adaptivePlatformDensity);
