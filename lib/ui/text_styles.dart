import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyles {
  static TextStyle quicksand(double size, Color color) => GoogleFonts.quicksand(
        textStyle: TextStyle(
          fontSize: size,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      );

  static TextStyle roboto(double size, Color color) => GoogleFonts.roboto(
        textStyle: TextStyle(
          fontSize: size,
          color: color,
        ),
      );
}
