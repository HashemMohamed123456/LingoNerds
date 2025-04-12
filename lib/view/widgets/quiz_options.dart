import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingonerds/model/exams/exams_data_model.dart';
class QuizOptionsCard extends StatelessWidget {
  const QuizOptionsCard({super.key,required this.quizOption,required this.color,required this.index});
  final Color color;
  final String quizOption;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: ListTile(
        title: Text(
          quizOption,style: GoogleFonts.anton(color:Colors.white,fontSize: 22),textAlign: TextAlign.start,),
      ),
    );
  }
}