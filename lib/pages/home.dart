import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:treehacks2021/pages/activity_feed.dart';
import 'package:treehacks2021/pages/profile.dart';
import 'package:treehacks2021/pages/search.dart';
import 'package:treehacks2021/pages/timeline.dart';
import 'package:treehacks2021/pages/upload.dart';
import 'package:treehacks2021/widgets/nav_bar_button.dart';
import 'package:treehacks2021/widgets/nav_bar_item.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
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

  // Scaffold buildAuthScreen() {
  //   double width = MediaQuery.of(context).size.width;
  //   return Scaffold(
  //     body: Stack(
  //       children: [
  //         Container(
  //           color: Colors.white,
  //         ),
  //         AnimatedContainer(
  //           margin: EdgeInsets.only(top: 79.0),
  //           duration: Duration(milliseconds: 375),
  //           curve: Curves.ease,
  //           height: (width < 800) ? collapsableHeight : 0.0,
  //           width: double.infinity,
  //           color: Colors.blue,
  //           child: SingleChildScrollView(
  //             child: Column(
  //               children: navBarItems,
  //             ),
  //           ),
  //         ),
  //         Container(
  //           color: Colors.purple,
  //           height: 80.0,
  //           padding: EdgeInsets.symmetric(horizontal: 24.0),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 'NavBar',
  //                 style: TextStyle(fontSize: 22.0, color: Colors.black),
  //               ),
  //               LayoutBuilder(builder: (context, constraints) {
  //                 if (width < 800.0) {
  //                   return NavBarButton(
  //                     onPressed: () {
  //                       if (collapsableHeight == 0.0) {
  //                         setState(() {
  //                           collapsableHeight = 240.0;
  //                         });
  //                       } else if (collapsableHeight == 240.0) {
  //                         setState(() {
  //                           collapsableHeight = 0.0;
  //                         });
  //                       }
  //                     },
  //                   );
  //                 } else {
  //                   return Row(
  //                     children: navBarItems,
  //                   );
  //                 }
  //               })
  //             ],
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  // List<Widget> navBarItems = [
  //   NavBarItem(text: 'Feed'),
  //   NavBarItem(text: 'Chat'),
  // ];
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
            onTap: manageWidgets,
            child: Icon(Icons.chat_bubble),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(Icons.search),
          ),
        ],
      ),
      body: Row(
        children: showChat ? getAll() : getFeed(),
      ),
    );
  }
  // body: Row(
  //   children: <Widget>[
  //     Column(
  //       children: [
  //         Expanded(
  //           child: Container(
  //             color: Colors.green,
  //             width: 100,
  //             child: Text("Static sidebar"),
  //           ),
  //         ),
  //       ],
  //     ),
  //     Expanded(
  //       child: Navigator(
  //         key: navigatorKey,
  //         initialRoute: '/',
  //         onGenerateRoute: FluroRouter.router.generator,
  //       ),
  //     )
  //   ],
  // ),

  // Scaffold buildAuthScreen() {
  //   return Scaffold(
  //     body: PageView(
  //       children: <Widget>[
  //         Timeline(),
  //         ActivityFeed(),
  //         Upload(),
  //         Search(),
  //         Profile(),
  //       ],
  //       controller: pageController,
  //       onPageChanged: onPageChanged,
  //       physics: NeverScrollableScrollPhysics(),
  //     ),
  //     bottomNavigationBar: CupertinoTabBar(
  //       currentIndex: pageIndex,
  //       onTap: onTap,
  //       activeColor: Colors.green,
  //       items: [
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.whatshot),
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.notifications_active),
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.photo_camera, size: 35.0),
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.search),
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.account_circle),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget buildNoAuthScreen() {
    return Column(
      children: [
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
        )
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
