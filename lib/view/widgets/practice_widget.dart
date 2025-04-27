import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingonerds/model/practice/practice_model.dart';
import '../../core/themes/app_themes.dart';

class PracticeQuizWidget extends StatelessWidget {
  const PracticeQuizWidget({super.key,
    required this.indexAction,
    required this.quizQuestion
  });
  final int indexAction;
  final Question quizQuestion;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text('Q${indexAction +1}: ${quizQuestion.question}',style: GoogleFonts.anton(
          fontSize: 20,
          color: AppThemes.blueAppColor
      ),),
    );
  }
}