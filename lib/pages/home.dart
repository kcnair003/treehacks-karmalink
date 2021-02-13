import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treehacks2021/dynamicmodels/ThemeSelection.dart';

class Home extends StatelessWidget {
  bool isAuth = false;

  Widget buildAuthScreen() {
    return Text('Authenticated');
  }

  Widget buildNoAuthScreen() {
    return Scaffold (
      body: Column(
        children: <Widget>[
          Consumer<ThemeNotifier>(
              builder: (context, model, space) => Switch(
                  value: model.switchUse,
                  onChanged: (switchUse) => model.toggle())),
          Image(
            image: AssetImage('assets/images/logo.png'),
            width: 500,
            height: 250,
          ),
          GestureDetector(
              child: Container(
            width: 260,
            height: 60,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/signinBtn.png'),
              ),
            ),
          ))
        ],
      )
    );

    // return Column(
    //   Image(image: AssetImage('assets/images/logo.png'));
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildNoAuthScreen();
  }
}
