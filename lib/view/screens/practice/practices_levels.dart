// screens/practices_levels.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingonerds/core/themes/app_themes.dart';
import 'package:lingonerds/core/routes/routes.dart';
import 'package:lingonerds/view/widgets/progress_indicator_widget.dart';
import 'package:lingonerds/view_model/data/bloc/cubit/practices/practices_cubit.dart';
import '../../widgets/snackbar_custom.dart';

class PracticesLevels extends StatelessWidget {
  final String? practiceType;
  final String userId;

  const PracticesLevels({super.key, this.practiceType, required this.userId});

  @override
  Widget build(BuildContext context) {
    context.read<PracticesCubit>().fetchUserLevel(userId);

    return BlocConsumer<PracticesCubit, PracticesState>(
      listener: (context, state) {
        if (state is UserLevelErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading user level: ${state.error}')),
          );
        } else if (state is UserLevelLoadedState && state.userLevel == '') {
          Navigator.pushNamedAndRemoveUntil(
            context,
            ScreensRoutes.languageLevelTestScreenRoute,
                (route) => false,
          );
        } else if (state is QuestionsNotLoadedState) {
          var snackBar = SnackBarCustom.constructSnackBar(
              message: state.message, title: 'Error', num: 0);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      builder: (context, state) {
        var cubit = PracticesCubit.get(context);
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
                practiceType ?? "Vocabulary Practice",
                style: AppThemes.lightTheme.textTheme.labelLarge,
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: state is UserLevelLoadingState || state is QuestionsLoadingState
                  ? Center(child: ProgressIndicatorClass.constructProgressIndicator())
                  : state is QuestionsNotLoadedState
                  ? Center(child: Text('Error: ${state.message}', style: GoogleFonts.anton(fontSize: 16.sp)))
                  : ListView.separated(
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      await cubit.selectLevel(cubit.levelsList[index], practiceType ?? 'Vocabulary Levels');
                      if (cubit.getCurrentLevelQuestions() != null) {
                        Navigator.pushNamed(context, ScreensRoutes.practiceScreenRoute);
                      } else {
                        var snackBar = SnackBarCustom.constructSnackBar(
                            message: 'Failed to load $practiceType questions', title: 'Error', num: 0);
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 100.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppThemes.blueAppColor,
                      ),
                      child: Center(
                        child: Text(
                          cubit.levelsList[index],
                          style: GoogleFonts.anton(
                            color: AppThemes.yellowAppColor,
                            fontSize: 30.sp,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Column(
                    children: [
                      SizedBox(height: 10.h),
                      Divider(
                        color: AppThemes.blueAppColor,
                        height: 2,
                      ),
                      SizedBox(height: 10.h),
                    ],
                  );
                },
                itemCount: cubit.levelsList.length,
              ),
            ),
          ),
        );
      },
    );
  }
}