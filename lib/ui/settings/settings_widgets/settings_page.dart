import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../colors.dart';
import 'settings_widgets.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({
    Key key,
    this.title,
    this.children,
  }) : super(key: key);

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: backgroundGrey,
        appBar: MyAppBar(
          onBack: () {
            Navigator.pop(context);
          },
          titleText: title,
          color: blue3,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
