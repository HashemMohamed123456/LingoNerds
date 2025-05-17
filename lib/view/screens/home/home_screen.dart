import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingonerds/core/routes/routes.dart';
import 'package:lingonerds/core/themes/app_themes.dart';
import 'package:lingonerds/model/category/category_model.dart';
import 'package:lingonerds/view/widgets/categories_widget.dart';
import 'package:lingonerds/view/widgets/elevated_button_custom.dart';
import 'package:lingonerds/view/widgets/progress_indicator_widget.dart';
import 'package:lingonerds/view_model/data/bloc/cubit/auth/auth_cubit.dart';
import 'package:lingonerds/view_model/data/bloc/cubit/auth/auth_states.dart';
import '../../../core/firebase/firestore_handler.dart';
import '../../widgets/snackbar_custom.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<CategoryModel> categoriesList = [
    CategoryModel(image: 'assets/icons/chalkboard.png', categoryTitle: 'Level Exam'),
    CategoryModel(image: 'assets/icons/dictionary.png', categoryTitle: 'Dictionary'),
    CategoryModel(image: 'assets/icons/microphone.png', categoryTitle: 'Transcriber'),
    CategoryModel(image: 'assets/icons/word-of-mouth.png', categoryTitle: 'Pronunciation Coach'),
    CategoryModel(image: 'assets/icons/study.png', categoryTitle: 'Practices'),
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/scaffold.png')),
      ),
      child: BlocProvider(
        create: (context) => AuthCubit()..loadUserData(),
        child: BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) {
            if (state is LoadingUserDataState) {
              ProgressIndicatorClass.constructProgressIndicator();
            } else if (state is SignOutSuccessState) {
              var snack = SnackBarCustom.constructSnackBar(
                message: "You're Signed Out Successfully !",
                title: 'SUCCESS',
                num: 1,
              );
              ScaffoldMessenger.of(context).showSnackBar(snack);
              Navigator.pushNamedAndRemoveUntil(context, ScreensRoutes.loginScreenRoute, (route) => false);
            } else if (state is LoadingUserDataErrorState) {
              var snack = SnackBarCustom.constructSnackBar(
                message: state.message,
                title: 'ERROR',
                num: 0,
              );
              ScaffoldMessenger.of(context).showSnackBar(snack);
            } else if (state is ProfileUpdateSuccessState) {
              var snack = SnackBarCustom.constructSnackBar(
                message: 'Profile updated. To use the new email for login, please verify it or contact support.',
                title: 'INFO',
                num: 2,
              );
              ScaffoldMessenger.of(context).showSnackBar(snack);
            } else if (state is UserDataLoadedState) {
              debugPrint("HomeScreen: UserDataLoadedState emitted, level: ${state.userData.languageLevel}");
            }
          },
          builder: (context, state) {
            if (state is SignOutSuccessState) {
              return SizedBox();
            }
            return Scaffold(
              key: _scaffoldKey,
              drawer: Drawer(
                key: ValueKey(state is UserDataLoadedState ? state.userData.languageLevel : 'drawer'),
                backgroundColor: AppThemes.blueAppColor,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: BlocBuilder<AuthCubit, AuthStates>(
                      buildWhen: (previous, current) =>
                      current is UserDataLoadedState || current is LoadingUserDataState || current is LoadingUserDataErrorState,
                      builder: (context, state) {
                        final authCubit = context.read<AuthCubit>();
                        if (state is LoadingUserDataState) {
                          return Center(child: ProgressIndicatorClass.constructProgressIndicator());
                        } else if (state is UserDataLoadedState) {
                          final user = state.userData;
                          debugPrint("HomeScreen: Drawer rebuilding with level: ${user.languageLevel}");
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                user.name ?? 'No Name',
                                style: GoogleFonts.anton(
                                  color: AppThemes.yellowAppColor,
                                  fontSize: 30,
                                ),
                              ),
                              SizedBox(height: 25.h),
                              Text(
                                user.email ?? 'No Email',
                                style: GoogleFonts.anton(
                                  color: AppThemes.yellowAppColor,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 25.h),
                              Text(
                                user.languageLevel ?? 'No Level',
                                style: GoogleFonts.anton(
                                  color: AppThemes.yellowAppColor,
                                  fontSize: 25,
                                ),
                              ),
                              SizedBox(height: 50.h),
                              CircleAvatar(
                                radius: 150,
                                backgroundColor: AppThemes.yellowAppColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Image.asset(
                                      'assets/images/app_logo.png',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                              ElevatedButtonCustom(
                                buttonLabel: 'Edit Profile',
                                onPressed: () {
                                  _scaffoldKey.currentState?.closeDrawer();
                                  Navigator.pushNamed(context, ScreensRoutes.editProfileScreenRoute).then((result) {
                                    if (result == true) {
                                      authCubit.loadUserData();
                                    }
                                  });
                                },
                              ),
                              SizedBox(height: 25.h),
                              ElevatedButtonCustom(
                                buttonLabel: 'Logout',
                                onPressed: () {
                                  authCubit.signOut();
                                },
                              ),
                            ],
                          );
                        } else if (state is LoadingUserDataErrorState) {
                          return Column(
                            children: [
                              Text(
                                'Error: ${state.message}',
                                style: GoogleFonts.anton(color: Colors.red),
                              ),
                              SizedBox(height: 25.h),
                              ElevatedButtonCustom(
                                buttonLabel: 'Retry',
                                onPressed: () => authCubit.loadUserData(),
                              ),
                            ],
                          );
                        }
                        return Center(child: Text('Please sign in'));
                      },
                    ),
                  ),
                ),
              ),
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        'Ready To Learn !?',
                        style: AppThemes.lightTheme.textTheme.labelLarge,
                      ),
                      SizedBox(height: 20.h),
                      // Debug button for manual refresh
                      ElevatedButtonCustom(
                        onPressed: () => context.read<AuthCubit>().loadUserData(),
                        buttonLabel: 'Refresh',
                      ),
                      SizedBox(height: 20.h),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                          ),
                          itemCount: categoriesList.length,
                          itemBuilder: (context, index) {
                            return CategoriesWidget(
                              onTap: () {
                                if (categoriesList[index].categoryTitle == "Level Exam") {
                                  Navigator.pushNamed(context, ScreensRoutes.vocabularyTestsScreenRoute).then((result) {
                                    if (result == true) {
                                      context.read<AuthCubit>().loadUserData();
                                      debugPrint("HomeScreen: Reloaded AuthCubit after test");
                                    }
                                  });
                                } else if (categoriesList[index].categoryTitle == "Dictionary") {
                                  Navigator.pushNamed(context, ScreensRoutes.dictionaryScreenRoute);
                                } else if (categoriesList[index].categoryTitle == "Transcriber") {
                                  Navigator.pushNamed(context, ScreensRoutes.voiceAnalysisScreenRoute);
                                } else if (categoriesList[index].categoryTitle == "Pronunciation Coach") {
                                  Navigator.pushNamed(context, ScreensRoutes.pronunciationCoachScreen);
                                } else {
                                  Navigator.pushNamed(context, ScreensRoutes.practiceCategoriesScreen);
                                }
                              },
                              categoryImage: categoriesList[index].image,
                              categoryTitle: categoriesList[index].categoryTitle,
                              categoryModel: categoriesList[index],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}