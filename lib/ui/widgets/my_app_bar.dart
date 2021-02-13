import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../colors.dart';

class MyAppBar extends AppBar {
  MyAppBar({
    Key key,
    Function onBack,
    String titleText,
    Color color,
    bool leadingNull = false,
    List<Widget> actions,
  }) : super(
          key: key,
          leading: leadingNull
              ? null
              : IconButton(
                  icon: Icon(
                    Icons.keyboard_arrow_left,
                    color: color,
                    size: 35,
                  ),
                  onPressed: onBack,
                ),
          title: Text(
            titleText,
            style: GoogleFonts.quicksand(
              fontSize: 32,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: actions,
          elevation: 0,
          backgroundColor: backgroundGrey,
          automaticallyImplyLeading: false,
        );

  /// Color of the back icon and title.
  static Color color;

  /// Whether the leading property of the superclass AppBar should be null.
  static bool leadingNull;
}
