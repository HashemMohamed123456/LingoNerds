import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/themes/app_themes.dart';
class ElevatedButtonCustom extends StatelessWidget {
   void Function()? onPressed;
   String? buttonLabel;
   ElevatedButtonCustom({super.key,this.onPressed,this.buttonLabel});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed:onPressed,
      style:ElevatedButton.styleFrom(
          backgroundColor: AppThemes.yellowAppColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
          minimumSize: Size(348.w,60.h)
      ) , child:Text(buttonLabel??"",style: AppThemes.lightTheme.textTheme.titleMedium,),);
  }
}
