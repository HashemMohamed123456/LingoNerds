import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lingonerds/core/routes/routes.dart';
import 'package:lingonerds/core/themes/app_themes.dart';
import 'package:lingonerds/view/widgets/onboarding_card.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  // Navigate to the next page or the level test screen
  void navigateToPage(int page) {
    if (page < 4) {
      pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 400),
        curve: Curves.linear,
      );
    } else {
      Navigator.pushNamed(context, ScreensRoutes.languageLevelTestScreenRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> onBoardingPages = [
      OnboardingCard(
        image: 'assets/icons/stack-of-books.png',
        title: 'Welcome!',
        description:
        'Welcome to Lingonerds! Our app will help you enhance your language skills and reach advanced levels.',
        onPressed: () => navigateToPage(1),
        buttonLabel: 'Next',
      ),
      OnboardingCard(
        image: 'assets/icons/exam.png',
        title: 'Quizzes & Exams',
        description:
        'Assess and improve your language level with our vocabulary and grammar exams, tests, and quizzes.',
        onPressed: () => navigateToPage(2),
        buttonLabel: 'Next',
      ),
      OnboardingCard(
        image: 'assets/icons/mobile.png',
        title: 'Conversation Simulation',
        description:
        'Get feedback on pronunciation and grammar with our conversation simulation service.',
        onPressed: () => navigateToPage(3),
        buttonLabel: 'Next',
      ),
      OnboardingCard(
        image: 'assets/icons/check-list.png',
        title: 'Level Test',
        description:
        'Start your journey and take our language level test to enhance your skills!',
        onPressed: () => navigateToPage(4),
        buttonLabel: "Let's Go",
      ),
    ];

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/scaffold.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: PageView(
                controller: pageController,
                children: onBoardingPages,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: SmoothPageIndicator(
                effect: ExpandingDotsEffect(
                  dotColor: AppThemes.blueAppColor,
                  activeDotColor: AppThemes.yellowAppColor,
                  dotHeight: 8.h,
                  dotWidth: 8.w,
                  spacing: 8.w,
                ),
                controller: pageController,
                count: onBoardingPages.length,
                onDotClicked: navigateToPage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}