import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingonerds/model/exams/exams_data_model.dart';

import '../../core/themes/app_themes.dart';

class QuizWidget extends StatelessWidget {
  const QuizWidget({super.key,
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