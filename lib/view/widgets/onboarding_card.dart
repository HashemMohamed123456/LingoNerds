import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingonerds/core/themes/app_themes.dart';
import 'package:lingonerds/view/widgets/elevated_button_custom.dart';

class OnboardingCard extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final VoidCallback? onPressed;
  final String? buttonLabel;

  const OnboardingCard({
    super.key,
    this.onPressed,
    required this.image,
    required this.title,
    required this.description,
    this.buttonLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(20.h),
                child: Image.asset(
                  image,
                  height: 150.h,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 16.h),
              Column(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 350.w),
                    child: Text(
                      title,
                      style: GoogleFonts.anton(
                        color: AppThemes.blueAppColor,
                        fontSize: 25.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 350.w),
                    child: Text(
                      description,
                      style: GoogleFonts.poppins(
                        color: AppThemes.blueAppColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              ElevatedButtonCustom(
                buttonLabel: buttonLabel,
                onPressed: onPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}