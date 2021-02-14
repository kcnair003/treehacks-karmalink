import 'package:flutter/material.dart';

class TellUserToUpdateDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Oil Finder needs a software update. Please check your email for the lastest version or ask me for help at spencerchubb@gmail.com',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
