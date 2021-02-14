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
