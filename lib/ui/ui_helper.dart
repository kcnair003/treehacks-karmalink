import 'package:flutter/material.dart';

class MyNavigator {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static void push(Widget page) {
    navigatorKey.currentState.push(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  static void pushAndRemoveUntil(Widget page) {
    navigatorKey.currentState.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => page,
      ),
      (route) => false,
    );
  }

  static void pop() {
    navigatorKey.currentState.pop();
  }
}

extension MediaQueryContext on BuildContext {
  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.width;
}

extension ThemeContext on BuildContext {
  ThemeData get theme => Theme.of(this);
}

extension OilFinderColors on Colors {}

class TextStyles {}
