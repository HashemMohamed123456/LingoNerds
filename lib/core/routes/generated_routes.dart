import 'package:flutter/material.dart';
import 'package:lingonerds/core/routes/routes.dart';
import 'package:lingonerds/view/screens/conversatiton/conversation_simulation_screen.dart';
import 'package:lingonerds/view/screens/dictionary/dictionary_screen.dart';
import 'package:lingonerds/view/screens/forgetPassword/forget_password_screen.dart';
import 'package:lingonerds/view/screens/grammar/grammar_tests_screen.dart';
import 'package:lingonerds/view/screens/home/home_screen.dart';
import 'package:lingonerds/view/screens/levelTest/level_test_screen.dart';
import 'package:lingonerds/view/screens/onboarding/onboarding_screen.dart';
import 'package:lingonerds/view/screens/pronunciation/pronuncaition_test_screen.dart';
import 'package:lingonerds/view/screens/signUp/sign_up_screen.dart';
import 'package:lingonerds/view/screens/splash/splash_screen.dart';
import 'package:lingonerds/view/screens/verification/verification_screen.dart';
import 'package:lingonerds/view/screens/vocabulary/vocabulary_tests_screen.dart';
import '../../view/screens/login/login_screen.dart';
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
    }else if(name==ScreensRoutes.conversationScreenRoute){
      return MaterialPageRoute(builder: (context)=>ConversationSimulationScreen());
    }else if(name==ScreensRoutes.dictionaryScreenRoute){
      return MaterialPageRoute(builder: (context)=>DictionaryScreen());
    }else if(name==ScreensRoutes.grammarTestsScreenRoute){
      return MaterialPageRoute(builder: (context)=>GrammarTestsScreen());
    }else if(name==ScreensRoutes.vocabularyTestsScreenRoute){
      return MaterialPageRoute(builder: (context)=>VocabularyTestsScreen());
    }else if(name==ScreensRoutes.pronunciationTestScreen){
      return MaterialPageRoute(builder: (context)=>PronunciationTestScreen());
    }
    return null;
  }
}