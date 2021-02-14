import 'package:flutter/material.dart';

Color selected = Colors.orange;
Color notSelected = Colors.white;

class NavBarItem extends StatefulWidget {
  final String text;
  NavBarItem({
    this.text,
  });

  @override
  _NavBarItemState createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem> {
  Color color = notSelected;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (value) {
        setState(() {
          color = selected;
        });
      },
      onExit: (value) {
        setState(() {
          color = notSelected;
        });
      },
      child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.white60,
            onTap: () {},
            child: Container(
              height: 60.0,
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: 16.0,
                  color: color,
                ),
              ),
            ),
          )),
    );
  }
}
