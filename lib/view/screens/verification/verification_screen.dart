import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingonerds/view/widgets/elevated_button_custom.dart';
import 'package:lingonerds/view/widgets/text_form_field_custom.dart';
import 'package:lingonerds/view/widgets/verification_code_widget.dart';

import '../../../core/routes/routes.dart';
import '../../../core/themes/app_themes.dart';
class PasswordVerificationScreen extends StatelessWidget {
  const PasswordVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/scaffold.png'))
      ),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding:  EdgeInsets.only(top:132.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Verification',style: AppThemes.lightTheme.textTheme.labelLarge,),
                    SizedBox(height: 32.h,),
                    Text('Please Enter Your Verification Code',style: AppThemes.lightTheme.textTheme.labelMedium,),
                    SizedBox(height: 20.h,),
                    SizedBox(
                      height: 50.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (context,index){
                        return VerificationCodeWidget();
                      }, separatorBuilder: (context,index)=>SizedBox(width: 20.w,), itemCount: 4),
                    ),
                    SizedBox(height: 12.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("If You Didn't Receive Code",style:AppThemes.lightTheme.textTheme.labelMedium,),
                        TextButton(onPressed:(){
                        }, child:Text('Resend',style: GoogleFonts.poppins(
                          decoration: TextDecoration.underline,
                          decorationColor:Colors.red,
                          fontSize: 16,
                          color: Colors.red,
                        ),)),
                      ],
                    ),
                    SizedBox(height: 30.h,),
                    ElevatedButtonCustom(
                      buttonLabel: 'Send',
                      onPressed: (){},
                    ),
                    SizedBox(height: 112.h,),
                    Image.asset('assets/images/app_logo.png',height: 216.h,width: 212.w,)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
