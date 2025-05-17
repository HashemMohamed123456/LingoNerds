import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lingonerds/pronunciation/AudioRecord/Repository/fluentme_repository_impl.dart';
import 'package:lingonerds/pronunciation/AudioRecord/services/record_service.dart';
import 'package:lingonerds/pronunciation/AudioRecord/view_model/audio_player_viewModel/audio_player_cubit.dart';
import 'package:lingonerds/pronunciation/AudioRecord/view_model/fluentme_viewModel/fluentMe_cubit.dart';
import 'package:lingonerds/pronunciation/AudioRecord/view_model/record_cubit.dart';
import 'package:lingonerds/pronunciation/AudioRecord/view_model/viewModel/cubits/VoiceCubit.dart';
import 'package:lingonerds/pronunciation/Data/Repo/VoiceAnalysisRepoImpl.dart';
import 'package:lingonerds/theNerd/core/di/di.dart';
import 'package:lingonerds/view_model/data/bloc/bloc_observer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lingonerds/view_model/data/bloc/cubit/auth/auth_cubit.dart';
import 'package:lingonerds/view_model/data/bloc/cubit/practices/practices_cubit.dart';
import 'package:lingonerds/view_model/data/local/local_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/routes/generated_routes.dart';
import 'core/routes/routes.dart';
import 'core/themes/app_themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await LocalData.init();
  Bloc.observer = MyBlocObserver();
  await Supabase.initialize(
      url: 'https://lfqdlpvjbhhagoscgzum.supabase.co', // from your Supabase dashboard
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxmcWRscHZqYmhoYWdvc2NnenVtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ1OTI2MjQsImV4cCI6MjA2MDE2ODYyNH0.Y2ewF3u1Q27wS1iP4qyYE68h9smN8EyoCWJTxNcSHbg'
  );
  await configureDependencies();
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
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context)=>PracticesCubit()),
          BlocProvider(create: (_) => RecordCubit(RecordService())),
          BlocProvider(create: (_) => AudioPlayerCubit(AudioPlayer())),
          BlocProvider(create: (_) => VoiceCubit(VoiceAnalysisRepoImpl()),),
          BlocProvider(create: (_) => FluentMeCubit(repository: FluentMeRepository()),),
          BlocProvider(create: (context)=>AuthCubit())
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppThemes.lightTheme,
          themeMode: ThemeMode.light,
          onGenerateRoute: GenerateRoute.onGenerateRoute,
          initialRoute: ScreensRoutes.lingoChatScreen,
        ),
      ),
    );
  }
}

