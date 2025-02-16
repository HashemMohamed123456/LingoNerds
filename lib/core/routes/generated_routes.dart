import 'package:flutter/material.dart';
import 'package:lingonerds/core/routes/routes.dart';
import 'package:lingonerds/view/screens/splash/splash_screen.dart';
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
    }
    return null;
  }
}