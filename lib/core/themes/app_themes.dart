import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class AppThemes{
  static const Color blueAppColor = Color(0xFF130F40);
  static const Color scaffoldColor=Color(0xFFFFFFFF);
  static const Color textFormFieldFocusColor=Color(0xFFF0EDFFCC);
  static const Color textFormFieldColor=Color(0xFF8888887A);
  static ThemeData lightTheme = ThemeData(
      textTheme: TextTheme(
        labelSmall: GoogleFonts.poppins(color: blueAppColor,fontSize:16),
        labelLarge: GoogleFonts.anton(color:blueAppColor, fontSize: 27),
      ));
}