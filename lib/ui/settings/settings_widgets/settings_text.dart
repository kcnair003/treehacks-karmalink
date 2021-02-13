import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../size_config.dart';
import '../../widgets/content_animation.dart';

class BodyText extends StatelessWidget {
  /// Use as body text. Comes with styling and the show up animation.
  BodyText({this.delay, this.text});

  final int delay;
  final String text;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return ContentAnimation(
      delay: delay,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.lato(
          textStyle: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
            fontSize: SizeConfig.h * 4.3,
          ),
        ),
      ),
    );

    // return ShowAnimation(
    //   delay: delay,
    //   duration: 900,
    //   child: Text(
    //     text,
    //     textAlign: TextAlign.center,
    //     style: GoogleFonts.lato(
    //       textStyle: TextStyle(
    //         color: Colors.grey[600],
    //         fontWeight: FontWeight.w400,
    //         fontSize: SizeConfig.h * 4.3,
    //       ),
    //     ),
    //   ),
    // );
  }
}

class CaptionText extends StatelessWidget {
  CaptionText(this.text, {Key key}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: GoogleFonts.quicksand(
        textStyle: TextStyle(
          fontSize: SizeConfig.h * 4.1,
          color: Colors.grey[700],
          decoration: TextDecoration.underline,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
