import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingonerds/core/themes/app_themes.dart';
import 'package:lingonerds/view/widgets/elevated_button_custom.dart';
class OnboardingCard extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final void Function()? onPressed;
  final String? buttonLabel;
  const OnboardingCard({super.key,this.onPressed,required this.image,required this.title,required this.description,this.buttonLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height*0.80,
      width: MediaQuery.sizeOf(context).width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Image.asset(image,fit: BoxFit.contain,),
          ),
          Column(
            children: [
              Text(title,style: GoogleFonts.anton(color: AppThemes.blueAppColor,fontSize: 25,),textAlign: TextAlign.center,),
              Text(description,
                style: GoogleFonts.poppins(
                    color: AppThemes.blueAppColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,),
            ],
          ),
          ElevatedButtonCustom(buttonLabel:buttonLabel,onPressed:onPressed,)
        ],
    ),
    );
  }
}
