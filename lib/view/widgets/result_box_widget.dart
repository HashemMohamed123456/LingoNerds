import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingonerds/core/themes/app_themes.dart';

class ResultBox extends StatelessWidget {
  const ResultBox({
    super.key,
    required this.result,
    required this.questionLength,
    this.onTap,
    this.languageLevel,
    required this.isC2Level, // Add this parameter
  });

  final int result;
  final int questionLength;
  final void Function()? onTap;
  final String? languageLevel;
  final bool isC2Level; // To check if current level is C2

  @override
  Widget build(BuildContext context) {
    final passed = result >= questionLength * 0.6;
    final isC2AndPassed = isC2Level && passed;

    return AlertDialog(
      backgroundColor: AppThemes.blueAppColor,
      content: Padding(
        padding: const EdgeInsets.all(70),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Score',
              style: GoogleFonts.anton(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 70,
              backgroundColor: result == questionLength / 2
                  ? AppThemes.yellowAppColor
                  : result < questionLength / 2
                  ? AppThemes.incorrectColor
                  : AppThemes.correctColor,
              child: Text(
                '$result/$questionLength',
                style: GoogleFonts.anton(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isC2AndPassed
                  ? 'Congratulations! You\'ve mastered C2 level and all of Our Levels!' // Special message for C2
                  : passed
                  ? 'Congratulations! You Passed! Your Level Now is $languageLevel!'
                  : 'Sorry You Failed! Your Level is still $languageLevel!',
              style: GoogleFonts.anton(
                color: Colors.white,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            InkWell(
              onTap: onTap,
              child: Text(
                isC2AndPassed
                    ? 'Done' // Changed button text for C2
                    : passed
                    ? 'Advance!'
                    : 'Start Over!',
                style: GoogleFonts.anton(
                  color: AppThemes.yellowAppColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}