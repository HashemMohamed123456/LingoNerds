import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lingonerds/core/firebase/firestore_handler.dart';
import 'package:lingonerds/core/routes/routes.dart';
import 'package:lingonerds/core/themes/app_themes.dart';
import 'package:lingonerds/view_model/data/local/local_data.dart';
class LingoSplashScreen extends StatefulWidget {
  const LingoSplashScreen({super.key});

  @override
  State<LingoSplashScreen> createState() => _LingoSplashScreenState();
}

class _LingoSplashScreenState extends State<LingoSplashScreen> with SingleTickerProviderStateMixin{
  bool isLoggedIn=LocalData.get(key:"isLoggedIn")??false;
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  var languageLevel=FireStoreHandler.getUserField(FirebaseAuth.instance.currentUser!.uid,"LanguageLevel");
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward();

    // Navigate to HomeScreen after 3 seconds
    Timer(Duration(seconds: 5), () {
      if (isLoggedIn) {
        if (languageLevel != null) {
          // If language level exists, navigate to the main home screen
          Navigator.pushNamedAndRemoveUntil(
              context, ScreensRoutes.mainHomeScreen, (route) => false);
        } else {
          // If language level is null, navigate to the language test screen
          Navigator.pushNamedAndRemoveUntil(
              context, ScreensRoutes.languageLevelTestScreenRoute, (route) => false);
        }
      } else {
        // If user is not logged in, navigate to the login screen
        Navigator.pushNamedAndRemoveUntil(
            context, ScreensRoutes.loginScreenRoute, (route) => false);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/scaffold.png'))
      ),
      child: Scaffold(
        body: Center(
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/app_logo.png', width:550.w), // Logo
               Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: 40.h),
                  child: Text('"Fluency Starts Here"',style:AppThemes.lightTheme.textTheme.labelLarge,),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
