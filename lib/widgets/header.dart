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

Widget header() {
  return Material(
    type: MaterialType.transparency,
    child: GradientAppBar("DialogueDen")
  );
}

class GradientAppBar extends StatelessWidget {

  final String title;
  final double barHeight = 75.0;

  GradientAppBar(this.title);

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
            fontSize: 50.0,
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