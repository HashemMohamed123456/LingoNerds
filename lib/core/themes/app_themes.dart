import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class AppThemes{
  static const Color blueAppColor = Color(0xFF130F40);
  static const Color textFormFieldErrorBorderColor=Color(0xFFCC1010);
  static const Color yellowAppColor=Color(0xFFF9A200);
  static  Color scaffoldBackgroundColor=Colors.white.withOpacity(0.70);
  static const Color correctColor=Color(0xFF32AB58);
  static const Color incorrectColor=Color(0xFFAB3232);
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: scaffoldBackgroundColor,
      textTheme: TextTheme(
        titleLarge: GoogleFonts.anton(color: blueAppColor,fontSize: 36),
        titleMedium: GoogleFonts.anton(color: blueAppColor,fontSize: 20),
        labelSmall: GoogleFonts.poppins(color:Colors.white,fontSize:16),
        labelMedium: GoogleFonts.poppins(color: blueAppColor,fontSize: 16),
        labelLarge: GoogleFonts.anton(color:blueAppColor, fontSize: 27),
      ));
}