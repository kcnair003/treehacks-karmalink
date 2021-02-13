import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  bool isAuth = false;

  Widget buildAuthScreen() {
    return Text('Authenticated');
  }

  Widget buildNoAuthScreen() {
    return Column(
      children: [
        Image(
          image: AssetImage('assets/images/logo.png'),
          width: 500,
          height: 250,
        ),
      ],
    );

    // return Column(
    //   Image(image: AssetImage('assets/images/logo.png'));
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildNoAuthScreen();
  }
}
