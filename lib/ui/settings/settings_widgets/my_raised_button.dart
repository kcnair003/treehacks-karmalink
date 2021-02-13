import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../colors.dart';

class MyRaisedButton extends RaisedButton {
  final String text;
  final Function() onPressed;

  MyRaisedButton({Key key, this.text = '', this.onPressed})
      : super(
          key: key,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              text,
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  fontSize: 24,
                  color: pureWhite,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          elevation: 5,
          onPressed: onPressed,
          color: purple3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
        );
}
