import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingonerds/core/themes/app_themes.dart';

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({super.key,
    required this.question,
    required this.indexAction,
    required this.totalQuestions});
  final String question;
  final int indexAction;
  final int totalQuestions;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text('Question ${indexAction +1}/$totalQuestions: $question',style: GoogleFonts.anton(
          fontSize: 20,
          color: AppThemes.blueAppColor
      ),),
    );
  }
}