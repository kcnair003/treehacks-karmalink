import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../colors.dart';
import '../size_config.dart';
import '../text_styles.dart';

class AlertPopUp extends StatefulWidget {
  AlertPopUp({
    this.text,
    this.onAccept,
    this.acceptText,
    this.onDecline,
    this.declineText,
  });

  final String text;
  final Function onAccept;
  final String acceptText;
  final Function onDecline;
  final String declineText;

  @override
  _AlertPopUpState createState() => _AlertPopUpState();
}

class _AlertPopUpState extends State<AlertPopUp> {
  @override
  void initState() {
    super.initState();
  }

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
            widget.text,
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 50,
            child: RaisedButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              elevation: 0,
              onPressed: widget.onAccept,
              color: purple2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  widget.acceptText,
                  style: TextStyles.quicksand(24, pureWhite),
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          FlatButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onPressed: widget.onDecline,
            color: pureWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(
                widget.declineText,
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    color: blue3,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
