import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lingonerds/core/themes/app_themes.dart';
import 'package:lingonerds/view/widgets/elevated_button_custom.dart';

import '../../../../core/routes/routes.dart';
import '../VoiceAnalysisView.dart';
import 'PronunciationAnalyzer.dart';
class Home extends StatelessWidget {

  static const String routeName="homepage";
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/scaffold.png'))
      ),
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent,
          title: Text("Pronunciation Coach",style: AppThemes.lightTheme.textTheme.labelLarge,),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/icons/tired.png',height: 400.h,width: 400.w,),
              SizedBox(height: 25.h),
              ElevatedButtonCustom(
                buttonLabel: 'Pronunciation Analyzer',
                onPressed: (){
                  Navigator.pushNamed(context,ScreensRoutes.pronunciationAnalyzerScreen);
                },
              ),
              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
