import 'package:flutter/material.dart';
import 'package:temporary/ui/colors.dart';

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundGrey,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
