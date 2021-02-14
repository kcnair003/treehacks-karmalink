import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../ui_helper.dart';

/// Builds a Row with some fancy tips taken from the source code of Flutter's BottomNavigationBar.
class MyBottomNavBar extends StatelessWidget {
  MyBottomNavBar({Key key, this.currentIndex}) : super(key: key);

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: context.theme.dividerColor,
            width: context.theme.dividerTheme.thickness,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NavBarIcon(
              icon: Icons.home_rounded,
              active: currentIndex == 0,
              // onTap: () => MyNavigator.push(HomeView()),
            ),
            NavBarIcon(
              icon: CupertinoIcons.briefcase_fill,
              active: currentIndex == 1,
              // onTap: () => MyNavigator.push(EnrollInYoungLivingView()),
            ),
          ],
        ),
      ),
    );
  }
}

class NavBarIcon extends StatelessWidget {
  NavBarIcon({
    Key key,
    this.icon,
    this.active,
    this.onTap,
  }) : super(key: key);

  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (active) {
      return Icon(
        icon,
        size: 30,
        color: context.theme.primaryColor,
      );
    }

    return InkResponse(
      onTap: onTap,
      child: Icon(
        icon,
        size: 30,
      ),
    );
  }
}
