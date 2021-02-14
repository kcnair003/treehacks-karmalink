import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treehacks2021/dynamicmodels/ThemeSelection.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _counter = 0;
  bool isAuth = false;

  Widget buildAuthScreen() {
    return Text('Authenticated');
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Widget buildNoAuthScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
 /*              stops: [
                0.5,
                //0.5,
                0.5,
              ], */
            colors: [
              Colors.blue,
              Colors.white,
              Colors.red,
            ])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
            )),
            Consumer<ThemeNotifier>(
                builder: (context, model, space) => Switch(
                    value: model.switchUse,
                    onChanged: (switchUse) => model.toggle())),
            ],
          ),
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildNoAuthScreen(context);
  }
}
