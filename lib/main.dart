import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dynamicmodels/ThemeSelection.dart';
import 'constants/Themes.dart';
import 'my_navigator.dart';
import 'pages/home.dart';

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
      navigatorKey: MyNavigator.navigatorKey,
      home: Home(title: appName),
    );
  }
}
