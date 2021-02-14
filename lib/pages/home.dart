import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:treehacks2021/my_navigator.dart';
import 'package:treehacks2021/pages/activity_feed.dart';
import 'package:treehacks2021/pages/profile.dart';
import 'package:treehacks2021/pages/search.dart';
import 'package:treehacks2021/pages/timeline.dart';
import 'package:treehacks2021/pages/upload.dart';
import 'package:treehacks2021/widgets/nav_bar_button.dart';
import 'package:treehacks2021/widgets/nav_bar_item.dart';
import 'package:treehacks2021/dynamicmodels/ThemeSelection.dart';
import 'package:provider/provider.dart';
import 'package:treehacks2021/widgets/theme_switch.dart';

import 'chat.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

// class Home extends StatefulWidget {
//   Home({Key key}) : super(key: key);
// import 'package:provider/provider.dart';

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
  bool isAuth = true;
  PageController pageController;
  int pageIndex = 0;
  List<Widget> displayWidgets;
  bool showChat = false;
  // get width => null;
  @override
  void initState() {
    super.initState();
    pageController = PageController();
    displayWidgets = displayList;
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      if (account != null) {
        print(account);
        setState(() {
          isAuth = true;
        });
      } else {
        setState(() {
          isAuth = false;
        });
      }
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  login() {
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.jumpToPage(pageIndex);
  }

  double collapsableHeight = 0.0;
  Color selected = Colors.orange;
  Color notSelected = Colors.lightBlue;

  List<Widget> displayList = [
    Expanded(
      child: Container(
        height: double.infinity,
        color: Colors.lightGreen,
        child: Text("Hello"),
      ),
    ),
    SizedBox(width: 3),
    Expanded(
      child: Container(
        height: double.infinity,
        color: Colors.lightBlue,
        child: Text("Hello"),
      ),
    ),
  ];

  List<Widget> getFeed() {
    return [displayList[0]];
  }

  List<Widget> getAll() {
    return displayList;
  }

  navigateToChat() {
    MyNavigator.push(ChatView());
  }

  manageWidgets() {
    setState(() {
      showChat = !showChat;
    });
    // List<Widget> added = displayList;
  }

  Scaffold buildAuthScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Karmalink or DialogueDen'),
        actions: [
          GestureDetector(
            onTap: () => navigateToChat(),
            child: Icon(Icons.chat_bubble),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(onTap: logout, child: Icon(Icons.logout)),
          ),
        ],
      ),
      body: Row(
        children: showChat ? getAll() : getFeed(),
      ),
    );
  }

  Widget buildNoAuthScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage('assets/images/logo.png'),
              width: 500,
              height: 250,
            ),
            GestureDetector(
              onTap: login,
              child: Container(
                width: 260,
                height: 60,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/signinBtn.png'),
                  ),
                ),
              ),
            ),
            ThemeSwitch(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildNoAuthScreen(context);
  }
}
