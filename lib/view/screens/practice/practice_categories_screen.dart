// view/screens/practice/practice_categories_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingonerds/core/routes/routes.dart';
import 'package:lingonerds/core/themes/app_themes.dart';

class PracticeCategoriesScreen extends StatelessWidget {
  const PracticeCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/scaffold.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'Practices Categories',
            style: AppThemes.lightTheme.textTheme.labelLarge,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/teacher.png',
                height: 200.h,
              ),
              SizedBox(height: 50.h),
              Text(
                'Choose Your Practice !',
                style: AppThemes.lightTheme.textTheme.labelLarge,
              ),
              SizedBox(height: 50.h),
              InkWell(
                onTap: () {
                  navigateToPracticesLevels(context, 'Vocabulary Levels');
                },
                child: Container(
                  height: 150.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppThemes.blueAppColor,
                  ),
                  child: Center(
                    child: Text(
                      'Vocabulary',
                      style: GoogleFonts.anton(
                        color: AppThemes.yellowAppColor,
                        fontSize: 50.sp,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              InkWell(
                onTap: () {
                  navigateToPracticesLevels(context, 'Grammar Levels');
                },
                child: Container(
                  height: 150.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppThemes.blueAppColor,
                  ),
                  child: Center(
                    child: Text(
                      'Grammar',
                      style: GoogleFonts.anton(
                        color: AppThemes.yellowAppColor,
                        fontSize: 50.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigateToPracticesLevels(BuildContext context, String practiceType) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (userId.isEmpty) {
      // Redirect to login if not authenticated
      Navigator.pushNamed(context, ScreensRoutes.loginScreenRoute);
    } else {
      // Navigate to PracticesLevels with practiceType and userId
      Navigator.pushNamed(
        context,
        ScreensRoutes.practicesLevelsScreen,
        arguments: {
          'practiceType': practiceType,
          'userId': userId,
        },
      );
    }
  }
}