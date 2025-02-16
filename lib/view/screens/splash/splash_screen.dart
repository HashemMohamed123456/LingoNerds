import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lingonerds/core/routes/routes.dart';
import 'package:lingonerds/core/themes/app_themes.dart';
class LingoSplashScreen extends StatefulWidget {
  const LingoSplashScreen({super.key});

  @override
  State<LingoSplashScreen> createState() => _LingoSplashScreenState();
}

class _LingoSplashScreenState extends State<LingoSplashScreen> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

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
      Navigator.pushNamed(
        context,
        ScreensRoutes.loginScreenRoute);
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
        backgroundColor:Colors.white.withOpacity(0.52),
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
