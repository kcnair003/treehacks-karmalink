import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:treehacks2021/widgets/postcard.dart';
import 'package:treehacks2021/widgets/theme_switch.dart';
import 'chat.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final postsRef = FirebaseFirestore.instance.collection('posts');
final usersRef = FirebaseFirestore.instance.collection('users');
// class Home extends StatefulWidget {
//   Home({Key key}) : super(key: key);
// import 'package:provider/provider.dart';

class Home extends StatefulWidget {

//   Home({Key key, this.title}) : super(key: key);

//   final String title;

  Home({Key key}) : super(key: key);


  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
//   String pendingPost = "";

//   int _counter = 0;

  PageController pageController;
  int pageIndex = 0;
  List<Widget> displayWidgets;
  List<Map> posts = [];
  bool showNewPost = false;
  List<Widget> displayList = [];
  // get width => null;

  User _user;

  @override
  void initState() {
    // final currUser = FirebaseAuth.instance.currentUser;
    getPosts();
    addToDisplayList(true);
    super.initState();

//     pageController = PageController();
//     googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
//       if (account != null) {
//         print(account);
//         print("enddddd");

//         setState(() {
//           isAuth = true;
//         });
//       } else {
//         setState(() {
//           isAuth = false;
//         });
//       }

    _user = context.read<AuthCubit>().state.user;

    pageController = PageController();
    displayWidgets = displayList;

  }

  getPosts() {
    postsRef.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        Map temp = new Map.from(doc.data());
        print(temp["user_id"]);
        usersRef.doc(temp["user_id"]).get().then((value) {
          temp["display_name"] = value.data()["display_name"] == null
              ? "person"
              : value.data()["display_name"];
          print(temp);
          posts.add(temp);
        });
      });
    });
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

  addToDisplayList(bool isFeed) {
    // getPosts();
    print(posts.length);
    print(posts.length);
    displayList.add(Expanded(
      child: Container(
        child: ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              print("Printing LIIII  ****** ");
              print(index);
              print("above is index");
              print(posts[index]);
              return PostCard(
                  posts[index]["message"], posts[index]["display_name"]);
            }),
      ),
    ));
    if (isFeed == false) {
      displayList.add(SizedBox(width: 3));

      // displayList.add(Expanded)
      displayList.add(Expanded(
        child: Container(
          height: double.infinity,
          color: Colors.lightGreen,
          child: Column(
            children: [
              new Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  decoration: new BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: new Border.all(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  child: new TextField(
                    onChanged: (val) {
                      changeContent(val);
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    textAlign: TextAlign.left,
                    decoration: new InputDecoration(
                        hintText: 'Write Something To Post...',
                        contentPadding: EdgeInsets.all(15),
                        border: InputBorder.none,
                        labelStyle: TextStyle(fontSize: 20)),
                    // hintStyle: TextStyle(fontSize: 20)),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    final currUser = FirebaseAuth.instance.currentUser;

                    if (pendingPost != "") {
                      print("OutlineddButton onPressed");
                      print(currUser); // null
                      print(isAuth); // true
                      print(pendingPost);
                      // usersRef.doc(currUser.uid).get().then((value) {
                      //   postsRef.add({
                      //     "message": pendingPost,
                      //     "user_id": currUser.uid,
                      //     "time_posted": DateTime.now(),
                      //     "username": value.data()["username"] == null
                      //         ? "Person Pear"
                      //         : value.data()["username"]
                      //   });
                      // });
                      // print("Post ADDED TO FIREBASE");
                      manageWidgets();
                    }
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.post_add_rounded,
                        color: Colors.black,
                      ),
                      Text(
                        "Make a Post",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              // Container(
              //   child: ListView.builder(
              //       itemCount: posts.length,
              //       itemBuilder: (context, index) {
              //         return ListTile(title: posts[index]["message"]);
              //       }),
              // )
            ],
          ),
        ),
      ));
    }

    print("DONE addToDisplayList");
  }

  changeContent(value) {
    pendingPost = value;
  }

  List<Widget> getFeed() {
    displayList = [];
    addToDisplayList(true);
    return displayList;
  }

  List<Widget> getAll() {
    displayList = [];
    addToDisplayList(false);
    return displayList;
  }


  manageWidgets() {
    setState(() {
      showNewPost = !showNewPost;
    });
    // List<Widget> added = displayList;
  }

  navigateToChat() {
    MyNavigator.push(ChatView());

  }
  Scaffold buildAuthScreen() {
    // getPosts();
    // addToDisplayList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Karmalink or DialogueDen'),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: manageWidgets,
              child: Icon(Icons.post_add_rounded, size: 45),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: navigateToChat,
              child: Icon(Icons.chat_bubble, size: 36),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(onTap: logout, child: Icon(Icons.logout)),
          ),
        ],
      ),
      body: Row(
        children: showNewPost ? getAll() : getFeed(),
      ),
    );


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
