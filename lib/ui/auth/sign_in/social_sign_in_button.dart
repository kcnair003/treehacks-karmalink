import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common_widgets/custom_raised_button.dart';
import 'package:flutter/material.dart';

class SocialSignInButton extends CustomRaisedButton {
  SocialSignInButton({
    Key key,
    String assetName,
    String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  }) : super(
          key: key,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Image.asset(assetName),
              ),
              SizedBox(width: 8),
              Text(
                text,
                style: GoogleFonts.roboto(
                  color: textColor,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          color: color,
          onPressed: onPressed,
        );
}

class SignInButton extends CustomRaisedButton {
  SignInButton({
    Key key,
    @required String text,
    @required Color color,
    @required VoidCallback onPressed,
    Color textColor = Colors.black87,
    double height = 50.0,
  }) : super(
          key: key,
          child: Center(
            child: AutoSizeText(
              text,
              style: GoogleFonts.roboto(
                color: textColor,
                fontSize: 18,
              ),
              maxLines: 1,
            ),
          ),
          color: color,
          textColor: textColor,
          height: height,
          onPressed: onPressed,
        );
}
