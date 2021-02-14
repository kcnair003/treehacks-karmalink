import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/* AppBar header() {
  return GradientAppBar("DialogueDen"
    title: Text(
      "DialogueDen",
      style: GoogleFonts.permanentMarker(
        color: Colors.white,
        fontSize: 50.0,
      ),
    ),
    centerTitle: true,
    backgroundColor: Colors.blue,
    : Colors.red,
  );
} */

Widget header(context, String title, { bool isAppTitle = false }) {
  return Material(
    type: MaterialType.transparency,
    child: GradientAppBar(title, isAppTitle)
  );
}

class GradientAppBar extends StatelessWidget {

  final String title;
  final double barHeight = 75.0;
  final bool isAppTitle;

  GradientAppBar(this.title, this.isAppTitle);

  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery
        .of(context)
        .padding
        .top;

    return new Container(
      padding: EdgeInsets.only(top: statusbarHeight),
      height: statusbarHeight + barHeight,
      child: Center(
        child: Text(
          title,
          style: GoogleFonts.courgette(
            color: Colors.white,
            fontSize: isAppTitle ? 50.0 : 30.0,
          ),
        ),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.red, Colors.blue],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.5, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp
        ),
      ),
    );
  }
}