import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingonerds/view/widgets/result_box_widget.dart';
import '../../../core/themes/app_themes.dart';
import '../../../view_model/data/bloc/cubit/vocabulary/vocabulary_tests_cubit.dart';
import '../../widgets/next_button_widget.dart';
import '../../widgets/progress_indicator_widget.dart';
import '../../widgets/quiz_options.dart';
import '../../widgets/quiz_widget.dart';
import '../../widgets/snackbar_custom.dart';

class VocabularyTestsScreen extends StatelessWidget {
  const VocabularyTestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TestsCubit()..fetchUserData()..loadExamData(),
      child: BlocConsumer<TestsCubit, TestsState>(
        listener: (context, state) {
          if (state is AnswerNotSelectedState) {
            var snackBar = SnackBarCustom.constructSnackBar(
                message: 'You Must Answer !', title: 'Warning', num: 2);
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else if (state is AlreadySelectedAnswerState) {
            var snackBar = SnackBarCustom.constructSnackBar(
                message: "You Can't Change Your Answer !", title: 'Warning', num: 0);
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else if (state is LevelUpdatedState) {
            var snackBar = SnackBarCustom.constructSnackBar(
                message: 'Congratulations! Your level is now ${state.newLevel}',
                title: 'SUCCESS',
                num: 1);
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            debugPrint("VocabularyTestsScreen: Level updated to ${state.newLevel}");
          } else if (state is TestCompletedState) {
            // Delay navigation to ensure Firestore sync and AuthCubit completes
            Future.delayed(const Duration(milliseconds: 2000), () {
              Navigator.pop(context, true); // Return true to trigger reload
            });
          } else if (state is LevelUpdateErrorState) {
            var snackBar = SnackBarCustom.constructSnackBar(
                message: 'Error updating level: ${state.error}',
                title: 'ERROR',
                num: 0);
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            debugPrint("VocabularyTestsScreen: Level update error: ${state.error}");
          } else if (state is LastLevelC2State) {
            var snackBar = SnackBarCustom.constructSnackBar(
                message: 'You are already at the highest level (C2)!',
                title: 'INFO',
                num: 2);
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            debugPrint("VocabularyTestsScreen: At max level C2");
          }
        },
        builder: (context, state) {
          final cubit = context.read<TestsCubit>();

          if (state is ExamDataLoadingState || state is UserDataFetchingLoadingState) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/scaffold.png')),
              ),
              child: Scaffold(
                body: Center(child: ProgressIndicatorClass.constructProgressIndicator()),
              ),
            );
          }

          if (state is ExamDataLoadingErrorState) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                title: Text('Tests', style: AppThemes.lightTheme.textTheme.labelLarge),
              ),
              body: Center(
                child: Text(
                  'Error loading questions: ${state.error}',
                  style: TextStyle(color: Colors.red, fontSize: 18.sp),
                ),
              ),
            );
          }

          final questions = cubit.getLevelQuestions();

          if (questions.isEmpty) {
            return Center(child: ProgressIndicatorClass.constructProgressIndicator());
          }
          final currentIndex = cubit.index;
          final currentQuestion = questions[currentIndex];
          Color optionColor = AppThemes.blueAppColor;
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/scaffold.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                title: Text(
                  'Level Exam',
                  style: AppThemes.lightTheme.textTheme.labelLarge,
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'Score: ${cubit.score}',
                      style: GoogleFonts.anton(
                        color: AppThemes.blueAppColor,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ],
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: double.infinity,
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: AppThemes.yellowAppColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            "${cubit.userName}! Your Level is ${cubit.level}",
                            style: AppThemes.lightTheme.textTheme.titleMedium,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: QuizWidget(
                        indexAction: currentIndex,
                        quizQuestion: currentQuestion,
                      ),
                    ),
                    const SizedBox(height: 25),
                    ...List.generate(
                      currentQuestion.options.length,
                          (i) => InkWell(
                        onTap: () {
                          cubit.checkAnswerAndUpdate(currentQuestion, i);
                        },
                        child: QuizOptionsCard(
                          quizOption: currentQuestion.options[i],
                          color: cubit.getOptionColor(i, state),
                          index: i,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: NextButtonWidget(
                  nextButtonLabel: currentIndex == questions.length - 1
                      ? 'Finish'
                      : 'Next Question',
                  onTap: () {
                    if (currentIndex == questions.length - 1) {
                      if (!cubit.validateAnswerSelection()) return;
                      showDialog(
                        context: context,
                        builder: (ctx) => ResultBox(
                          result: cubit.score,
                          questionLength: questions.length,
                          languageLevel: cubit.score >= 0.6 * questions.length
                              ? cubit.getNextLevel(cubit.level!)
                              : cubit.level!,
                          isC2Level: cubit.level == 'C2',
                          onTap: () {
                            if (cubit.score <= questions.length * 0.6) {
                              cubit.startOver().then((_) {
                                Navigator.pop(context);
                              });
                            } else {
                              cubit.completeTest(questions, context);
                            }
                          },
                        ),
                      );
                    } else {
                      cubit.nextQuestion();
                    }
                  },
                ),
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            ),
          );
        },
      ),
    );
  }
}