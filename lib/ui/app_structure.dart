import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../constants/constants.dart';
import '../ui/text_styles.dart';
import 'colors.dart';
import 'project_level_data.dart';
import 'guided_journal/gj_home.dart';
import '../utility/transition.dart';
import 'size_config.dart';
import 'social_platform/create_post.dart';
import 'social_platform/feed.dart';
import 'social_platform/profile.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class AppStructure extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   backgroundColor: backgroundGrey,
    //   body: Navigator(
    //     key: navigatorKey,
    //     onGenerateRoute: (route) => MaterialPageRoute(
    //       settings: route,
    //       // builder: (_) => Home(),
    //       builder: (_) => GJHome(),
    //     ),
    //   ),
    //   bottomNavigationBar: navBar(context),
    // );
    return FutureBuilder(
      future: userNeedsToUpdate(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (!snapshot.data) {
            Future.delayed(
              Duration.zero,
              () => showDialog(
                context: context,
                builder: (_) => UpdateAlert(),
                barrierDismissible: false,
                barrierColor: purple1,
              ),
            );
          }

          return Scaffold(
            backgroundColor: backgroundGrey,
            body: Navigator(
              key: navigatorKey,
              onGenerateRoute: (route) => MaterialPageRoute(
                settings: route,
                // builder: (_) => Home(),
                builder: (_) => GJHome(),
              ),
            ),
            bottomNavigationBar: navBar(context),
          );
        } else {
          return Scaffold(backgroundColor: backgroundGrey);
        }
      },
    );
  }

  Widget navBar(BuildContext context) {
    bool showNavBar = Provider.of<NavState>(context).showNavBar;
    return showNavBar ? BottomNavigationBar() : null;
  }

  Future<bool> userNeedsToUpdate() async {
    final ref = FirebaseDatabase.instance.reference();
    DataSnapshot snapshot = await ref.child('releaseVersion').once();
    String value = snapshot.value;
    return Constants.releaseVersion == value;
  }
}

class BottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Container(
      height: SizeConfig.v * 9,
      width: SizeConfig.h * 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey[300],
            blurRadius: 8.0,
            spreadRadius: 4.0,
          ),
        ],
      ),
      child: ButtonBar(
        alignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // NavBarItem(
          //   tabIndex: 0,
          //   iconData: Icons.home_outlined,
          //   nextPage: Home(),
          // ),
          NavBarItem(
            tabIndex: 1,
            iconData: Icons.receipt_long,
            nextPage: GJHome(),
          ),
          NavBarItem(
            tabIndex: 2,
            iconData: Icons.people,
            selectedIconData: Icons.add_circle_outline,
            nextPage: Feed(),
          ),
          NavBarItem(
            tabIndex: 3,
            iconData: Icons.person,
            nextPage: Profile(uid: ProjectLevelData.user.uid),
          ),
        ],
      ),
    );
  }
}

class NavBarItem extends StatefulWidget {
  NavBarItem({
    this.tabIndex,
    this.iconData,
    this.selectedIconData,
    this.nextPage,
  });

  /// Index associated with this button of the bottomNavigationBar.
  final int tabIndex;
  final IconData iconData;
  final IconData selectedIconData;

  /// Page that the tab leads to.
  final Widget nextPage;

  @override
  _NavBarItemState createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem> {
  bool clicked = false;
  bool selected;

  @override
  Widget build(BuildContext context) {
    NavState model = Provider.of<NavState>(context, listen: false);
    int pageIndex = _pageIndex(context);
    selected = widget.tabIndex == pageIndex;
    return GestureDetector(
      onTap: () {
        if (pageIndex > widget.tabIndex) {
          push(Transition.leftToRight(next: widget.nextPage));
        } else if (pageIndex < widget.tabIndex) {
          push(Transition.rightToLeft(next: widget.nextPage));
        }
        model.setPageIndex(widget.tabIndex);
      },
      child: model.chooseNavBarItemChild(widget.iconData, selected),
    );
  }

  Future<void> push(Route route) {
    HapticFeedback.vibrate();
    return navigatorKey.currentState.push(route);
  }

  /// Returns the index of the page that the user is currently looking at.
  int _pageIndex(BuildContext context) {
    return Provider.of<NavState>(context).pageIndex;
  }
}

class NavState extends ChangeNotifier {
  int pageIndex = 1;

  void setPageIndex(int newPageIndex) {
    pageIndex = newPageIndex;
    notifyListeners();
  }

  bool showNavBar = true;

  void setShowNavBar(bool newshowNavBar) {
    showNavBar = newshowNavBar;
    notifyListeners();
  }

  Widget chooseNavBarItemChild(IconData iconData, bool selected) {
    if (selected && pageIndex == 2) {
      return CreatePostButton();
    }
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        color: selected ? yellow3 : Colors.grey[400],
        size: 40,
      ),
    );
  }
}

class CreatePostButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            orange2,
            purple2,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: GestureDetector(
        onTap: () => goToCreatePost(context),
        child: Icon(Icons.add, color: pureWhite),
      ),
    );
  }

  void goToCreatePost(BuildContext context) {
    Navigator.push(
      context,
      Transition.bottomToTop(
        next: CreatePost(),
      ),
    );
  }
}

class UpdateAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 200,
            width: 200,
            child: SvgPicture.asset('assets/notify.svg'),
          ),
          Text(
            'You must update to the latest version! Please contact the Hespr team if you are unsure of what to do',
            textAlign: TextAlign.center,
            style: TextStyles.quicksand(18, Colors.grey[600]),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
