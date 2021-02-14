import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:treehacks2021/dynamicmodels/ThemeSelection.dart';
import 'package:provider/provider.dart';

import 'create_account.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final usersRef = FirebaseFirestore.instance.collection('users');

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
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (err) {
      print('error signing in: $err');
    });

    //Reauthenticate user when app is opened
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }).catchError((err) {
      print('Error signing in: $err');
    });
  }

  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      print('User signed in!: $account');
      createUserInFirestore();
      print(account);
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }


  createUserInFirestore() async {
    // 1) Check if user exists in users collection in database (accoridng to their id)
    final GoogleSignInAccount user = googleSignIn.currentUser;
    final DocumentSnapshot doc = await usersRef.doc(user.id).get();

    // 2) If the user doesn't exist, then take them to the create account page
    if (!doc.exists) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => 
        CreateAccount()));
    }
    // 3) Get user name from create account and use it to make new user document in users collection
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
                )),
            Consumer<ThemeNotifier>(
                builder: (context, model, space) => Switch(
                    value: model.switchUse,
                    onChanged: (switchUse) => model.toggle())),
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
