import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:lingonerds/view_model/data/bloc/bloc_observer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/routes/generated_routes.dart';
import 'core/routes/routes.dart';
import 'core/themes/app_themes.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(412,917),
        minTextAdapt: true,
        splitScreenMode: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppThemes.lightTheme,
        themeMode: ThemeMode.light,
        onGenerateRoute: GenerateRoute.onGenerateRoute,
        initialRoute: ScreensRoutes.splashScreen,
      ),
    );
  }
}

