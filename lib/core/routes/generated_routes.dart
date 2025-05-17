import 'package:flutter/material.dart';
import 'package:lingonerds/core/routes/routes.dart';
import 'package:lingonerds/pronunciation/AudioRecord/view/PronunciationAnalyzer/Home.dart';
import 'package:lingonerds/pronunciation/AudioRecord/view/PronunciationAnalyzer/PronunciationAnalyzer.dart';
import 'package:lingonerds/pronunciation/AudioRecord/view/PronunciationAnalyzer/RecordingScreen.dart';
import 'package:lingonerds/pronunciation/AudioRecord/view/VoiceAnalysisView.dart';
import 'package:lingonerds/pronunciation/AudioRecord/view/record_screen.dart';
import 'package:lingonerds/theNerd/geminiteacher/presentation/widgets/chatscreenprovider.dart';
import 'package:lingonerds/view/screens/dictionary/dictionary_screen.dart';
import 'package:lingonerds/view/screens/editProfile/edit_profile_screen.dart';
import 'package:lingonerds/view/screens/forgetPassword/forget_password_screen.dart';
import 'package:lingonerds/view/screens/grammar/grammar_tests_screen.dart';
import 'package:lingonerds/view/screens/home/home_screen.dart';
import 'package:lingonerds/view/screens/levelTest/level_test_screen.dart';
import 'package:lingonerds/view/screens/onboarding/onboarding_screen.dart';
import 'package:lingonerds/view/screens/practice/practice_categories_screen.dart';
import 'package:lingonerds/view/screens/practice/practices_levels.dart';
import 'package:lingonerds/view/screens/pronunciation/pronuncaition_coach_screen.dart';
import 'package:lingonerds/view/screens/signUp/sign_up_screen.dart';
import 'package:lingonerds/view/screens/splash/splash_screen.dart';
import 'package:lingonerds/view/screens/transcriber/transcriber_screen.dart';
import 'package:lingonerds/view/screens/verification/verification_screen.dart';
import 'package:lingonerds/view/screens/practice/practice_screen.dart';
import 'package:lingonerds/view/screens/vocabulary/vocabulary_tests_screen.dart';
import '../../view/screens/login/login_screen.dart';
import 'package:lingonerds/pronunciation/Domain/Model/PostModel.dart';
class GenerateRoute {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    var args = settings.arguments;
    var name = settings.name;
    if (name == ScreensRoutes.splashScreen) {
      return MaterialPageRoute(
        builder: (context) => const LingoSplashScreen(),
      );
    }else if(name == ScreensRoutes.loginScreenRoute){
      return MaterialPageRoute(builder: (context)=> const LoginScreen());
    }else if(name== ScreensRoutes.signUpScreenRoute){
      return MaterialPageRoute(builder: (context)=>const SignUpScreen());
    }else if(name==ScreensRoutes.forgetPasswordScreenRoute){
      return MaterialPageRoute(builder: (context)=>ForgetPasswordScreen());
    }else if(name==ScreensRoutes.passwordVerificationScreenRoute){
      return MaterialPageRoute(builder: (context)=>PasswordVerificationScreen());
    }else if(name==ScreensRoutes.languageLevelTestScreenRoute){
      return MaterialPageRoute(builder: (context)=>LevelTestScreen());
    }else if(name==ScreensRoutes.onboardingScreenRoute){
      return MaterialPageRoute(builder: (context)=>OnboardingScreen());
    }else if(name==ScreensRoutes.mainHomeScreen){
      return MaterialPageRoute(builder: (context)=>HomeScreen());
    }else if(name==ScreensRoutes.transcriberScreenRoute){
      return MaterialPageRoute(builder: (context)=>TranscriberScreen());
    }else if(name==ScreensRoutes.dictionaryScreenRoute){
      return MaterialPageRoute(builder: (context)=>DictionaryScreen());
    }else if(name==ScreensRoutes.grammarTestsScreenRoute){
      return MaterialPageRoute(builder: (context)=>GrammarTestsScreen());
    }else if(name==ScreensRoutes.vocabularyTestsScreenRoute){
      return MaterialPageRoute(builder: (context)=>VocabularyTestsScreen());
    }else if(name==ScreensRoutes.pronunciationCoachScreen){
      return MaterialPageRoute(builder: (context)=>Home());
    }else if(name==ScreensRoutes.practiceCategoriesScreen){
      return MaterialPageRoute(builder: (context)=>PracticeCategoriesScreen());
    }else if(name==ScreensRoutes.lingoChatScreen){
      return MaterialPageRoute(builder: (context)=>ChatScreenProvider());
    }else if(name==ScreensRoutes.practicesLevelsScreen){
      if (args is Map<String, dynamic>) {
        String practiceType = args['practiceType'] ?? 'Vocabulary Practice';
        String userId = args['userId'] ?? '';
        if (userId.isEmpty) {
          // Redirect to login if userId is missing
          return MaterialPageRoute(builder: (context) => const LoginScreen());
        }
        return MaterialPageRoute(
          builder: (context) => PracticesLevels(
            practiceType: practiceType,
            userId: userId,
          ),
        );
      }
      // Fallback if args is not a map
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    }else if(name==ScreensRoutes.pronunciationAnalyzerScreen){
      return MaterialPageRoute(builder: (context)=>PostsScreen());
    }else if(name==ScreensRoutes.recordScreenRoute){
      final post=args as Post;
      return MaterialPageRoute(builder: (context)=>RecordScreen(post:post));
    }else if(name==ScreensRoutes.editProfileScreenRoute){
      return MaterialPageRoute(builder: (context)=>EditProfileScreen());
    }else if(name==ScreensRoutes.practiceScreenRoute){
      return MaterialPageRoute(builder: (context)=>PracticeScreen());
    }else if(name==ScreensRoutes.voiceAnalysisScreenRoute){
      return MaterialPageRoute(builder: (context)=>VoiceScreen());
    }
    return null;
  }
}