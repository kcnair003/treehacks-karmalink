import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treehacks2021/dynamicmodels/ThemeSelection.dart';

class ThemeSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, model, space) => Switch(
        value: model.switchUse,
        onChanged: (switchUse) => model.toggle(),
      ),
    );
  }
}
