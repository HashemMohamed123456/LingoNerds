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
  static final PageController pageController=PageController(initialPage: 0);
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    List<Widget>onBoardingPages=[
      OnboardingCard(image: 'assets/icons/stack-of-books.png',title: 'Welcome !',description: 'Welcome To Lingonerds Our Application Will help You To Enhance Your Language & Reach Advanced Levels!',onPressed: (){
        pageController.animateToPage(1, duration: Durations.long1, curve:Curves.linear);
      },buttonLabel: 'Next',),
      OnboardingCard(image: 'assets/icons/exam.png',title: 'Quizzes & Exams',description: 'Through Our Vocabulary and Grammar Exams,Tests & Quizzes You Can Know Your  Language Level & Enhance It',onPressed: (){
        pageController.animateToPage(2, duration: Durations.long1, curve:Curves.linear);
      },buttonLabel: 'Next',),
      OnboardingCard(image: 'assets/icons/mobile.png',title: 'Conversation Simulation !',description: 'Our Conversation Simulation Service Can Provide You Feedback For Pronunciation & Grammar',onPressed: (){
        pageController.animateToPage(3, duration: Durations.long1, curve:Curves.linear);
      },buttonLabel: "Next",),
      OnboardingCard(image: 'assets/icons/check-list.png',title: 'Level Test !',description: "Let's Begin Our Journey, Enhance Our Language & Begin Our Language Level Test !",onPressed: (){
        Navigator.pushNamed(context,ScreensRoutes.languageLevelTestScreenRoute);
      },buttonLabel: "Let's Go",),
    ];
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image:AssetImage('assets/images/scaffold.png'))
      ),
      child: Scaffold(
        body: Padding(
          padding:  EdgeInsets.symmetric(vertical: 50.h),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: PageView(
                  controller:pageController,
                  children:onBoardingPages,
                ),
              ),
          SmoothPageIndicator(
            effect: ExpandingDotsEffect(
              dotColor: AppThemes.blueAppColor,
              activeDotColor: AppThemes.yellowAppColor,
            ),
            controller:pageController,
            count:onBoardingPages.length,
            onDotClicked: (index){
              pageController.animateToPage(index,
                  duration: Durations.long1, curve:Curves.linear);
            },
          )
            ],
          ),
        ),
      ),
    );
  }
}
