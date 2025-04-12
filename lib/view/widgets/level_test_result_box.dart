import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingonerds/core/themes/app_themes.dart';

class LevelResultBox extends StatelessWidget {
  const LevelResultBox({super.key,required this.result,required this.questionLength,this.onTap,this.languageLevel});
  final int result;
  final int questionLength;
  final void Function()? onTap;
  final String? languageLevel;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor:AppThemes.blueAppColor ,
      content: Padding(padding: const EdgeInsets.all(70),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Score',style: GoogleFonts.anton(
                color: Colors.white,
                fontSize: 20
            ),),
            const SizedBox(height: 20,),
            CircleAvatar(
              radius: 70,
              backgroundColor:result==questionLength/2?AppThemes.yellowAppColor:
              result<questionLength/2?AppThemes.incorrectColor:AppThemes.correctColor,
              child: Text('$result/$questionLength',style:GoogleFonts.anton(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),),
            ),
            const SizedBox(height: 20,),
            Text(languageLevel!,
              style: GoogleFonts.anton(
                  color: Colors.white,
                  fontSize: 20
              ),),
            const SizedBox(height: 25,),
            InkWell(
              onTap:onTap,
              child:  Text('Advance!',style: GoogleFonts.anton(color:AppThemes.yellowAppColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0
              ),
              ),
            )
          ],),
      ),
    );
  }
}