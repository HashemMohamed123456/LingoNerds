import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingonerds/core/themes/app_themes.dart';

class NextButtonWidget extends StatelessWidget {
  final void Function()? onTap;
  final String nextButtonLabel;
  const NextButtonWidget({super.key,this.onTap,required this.nextButtonLabel});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppThemes.yellowAppColor,
              borderRadius: BorderRadius.circular(15)
        ),
        width: double.infinity,
        child: Text(nextButtonLabel,
          textAlign: TextAlign.center,
          style:GoogleFonts.anton(fontSize: 15,fontWeight: FontWeight.bold,color: AppThemes.blueAppColor,letterSpacing: 1.0),),
      ),
    );
  }
}