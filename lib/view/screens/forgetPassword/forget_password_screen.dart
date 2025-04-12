import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingonerds/core/themes/app_themes.dart';
import 'package:lingonerds/view/widgets/elevated_button_custom.dart';
import 'package:lingonerds/view/widgets/text_form_field_custom.dart';

import '../../../core/routes/routes.dart';
class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/scaffold.png'))
      ),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding:EdgeInsets.symmetric(vertical:70.h,horizontal:8.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Forgot Password?',style: AppThemes.lightTheme.textTheme.labelLarge,),
                  SizedBox(height: 90.h,),
                  Text('Please Enter Email Address',style: AppThemes.lightTheme.textTheme.labelLarge,),
                  SizedBox(height:28.h,),
                  TextFormFieldCustom(
                    hintText: 'Enter Your Email Address',
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.mail_outline,color: Colors.white,),
                  ),
                  SizedBox(height: 12.h,),
                  TextButton(onPressed:(){
                    Navigator.pushNamed(context,ScreensRoutes.loginScreenRoute);
                  }, child:Text('Back To Login?',style: GoogleFonts.anton(
                    decoration: TextDecoration.underline,
                    decorationColor:AppThemes.blueAppColor,
                    fontSize: 20,
                    color: AppThemes.blueAppColor,
                  ),)),
                  SizedBox(height: 30.h,),
                  ElevatedButtonCustom(
                    buttonLabel: 'Send',
                    onPressed: (){
                      Navigator.pushNamed(context,ScreensRoutes.passwordVerificationScreenRoute);
                    },
                  ),
                  SizedBox(height: 63.h,),
                  Image.asset('assets/images/app_logo.png',height:216.h,width:212.w),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
