import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dynamicmodels/ThemeSelection.dart';
import 'constants/Themes.dart';
import 'pages/home.dart';
import 'pages/timeline.dart';

void main() {
  runApp(ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final appName = 'KarmaLink';
    return MaterialApp(
      title: appName,
      theme: themeNotifier.selectedTheme,
      debugShowCheckedModeBanner: false,
      //home: Home(title: appName),
      home: Timeline(),
    );
  }
}
