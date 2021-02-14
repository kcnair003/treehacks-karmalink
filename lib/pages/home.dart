import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:treehacks2021/blocs/blocs.dart';
import 'package:treehacks2021/models/models.dart';
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
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController pageController;
  int pageIndex = 0;
  List<Widget> displayWidgets;
  bool showChat = false;
  // get width => null;

  User _user;

  @override
  void initState() {
    super.initState();

    _user = context.read<AuthCubit>().state.user;

    pageController = PageController();
    displayWidgets = displayList;
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(_user),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Karmalink or DialogueDen'),
          actions: [
            ThemeSwitch(),
            SizedBox(width: 16),
            MyDropDown(),
            SizedBox(width: 16),
            GestureDetector(
              onTap: () => navigateToChat(),
              child: Icon(Icons.chat_bubble),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () {
                  context.read<AuthCubit>().signOut();
                },
                child: Icon(Icons.logout),
              ),
            ),
          ],
        ),
        body: Row(
          children: showChat ? getAll() : getFeed(),
        ),
      ),
    );
  }
}

class MyDropDown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool likeMinded = context.watch<HomeCubit>().state.user.likeMinded;
    return DropdownButton(
      value: likeMinded,
      iconEnabledColor: Colors.white,
      underline: Container(
        height: 2,
        color: Colors.white,
      ),
      onChanged: (_) => context.read<HomeCubit>().toggleLikeMinded(),
      items: [
        DropdownMenuItem(
          value: true,
          child: Text('like-minded'),
        ),
        DropdownMenuItem(
          value: false,
          child: Text('different-minded'),
        ),
      ],
    );
  }
}
