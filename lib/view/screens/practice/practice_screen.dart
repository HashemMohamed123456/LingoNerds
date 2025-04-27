// screens/practice_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingonerds/core/themes/app_themes.dart';
import 'package:lingonerds/model/practice/practice_model.dart';
import 'package:lingonerds/view/widgets/elevated_button_custom.dart';
import 'package:lingonerds/view/widgets/progress_indicator_widget.dart';
import 'package:lingonerds/view_model/data/bloc/cubit/practices/practices_cubit.dart';
import '../../widgets/practice_widget.dart';
import '../../widgets/quiz_options.dart';
import '../../widgets/snackbar_custom.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PracticesCubit>();

    return BlocConsumer<PracticesCubit, PracticesState>(
      listener: (context, state) {
        if (state is AnswerNotSelectedState) {
          var snackBar = SnackBarCustom.constructSnackBar(message: 'You Must Answer !', title: 'Warning', num: 2);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (state is AlreadySelectedAnswerState) {
          var snackBar = SnackBarCustom.constructSnackBar(message: "You Can't Change Your Answer !", title: 'Warning', num: 0);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (state is QuizCompletedState) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: AppThemes.blueAppColor,
              title: Text('Practice Completed !', style: GoogleFonts.anton(fontSize: 20.sp, color: AppThemes.yellowAppColor)),
              content: Text(
                'Your score: ${state.score}/${state.totalQuestions}',
                style: GoogleFonts.anton(fontSize: 18.sp, color: Colors.white),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    await cubit.startOver();
                    Navigator.pop(context);
                  },
                  child: Text('Restart', style: GoogleFonts.anton(color: AppThemes.blueAppColor)),
                ),
              ],
            ),
          );
        } else if (state is QuestionsNotLoadedState) {
          var snackBar = SnackBarCustom.constructSnackBar(message: state.message, title: 'Error', num: 0);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (state is QuestionsLoadingErrorState) {
          var snackBar = SnackBarCustom.constructSnackBar(message: state.error, title: 'Error', num: 0);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      builder: (context, state) {
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
                '${cubit.practiceType} - ${cubit.selectedLevel}',
                style: AppThemes.lightTheme.textTheme.labelLarge,
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Let's Practice !!",
                    style: AppThemes.lightTheme.textTheme.labelLarge,
                  ),
                  SizedBox(height: 16.h),
                  if (state is QuestionsLoadingState || state is StartOverLoadingState)
                    Center(child: ProgressIndicatorClass.constructProgressIndicator())
                  else if (state is QuestionsLoadingErrorState)
                    Center(child: Text(
                        'Error: ${state.error}',
                        style: GoogleFonts.anton(fontSize: 16.sp)))
                  else if (state is QuestionsNotLoadedState)
                      Center(child: Text(
                          'Error: ${state.message}',
                          style: GoogleFonts.anton(fontSize: 16.sp)))
                    else if (cubit.currentQuestions.isNotEmpty && cubit.index < cubit.currentQuestions.length)
                        Expanded(
                          child: Column(
                            children: [
                              // Question
                              PracticeQuizWidget(
                                indexAction: cubit.index,
                                quizQuestion: cubit.currentQuestions[cubit.index],
                              ),
                              SizedBox(height: 25.h),
                              // Quiz options
                              ...List.generate(
                                cubit.currentQuestions[cubit.index].options.length,
                                    (i) => InkWell(
                                  onTap: () {
                                    cubit.checkAnswerAndUpdate(cubit.currentQuestions[cubit.index], i);
                                  },
                                  child: QuizOptionsCard(
                                    quizOption: cubit.currentQuestions[cubit.index].options[i],
                                    color: cubit.getOptionColor(i, state),
                                    index: i,
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              // Score display
                              Text(
                                'Score: ${cubit.score}',
                                style: GoogleFonts.anton(fontSize: 18.sp, color: AppThemes.blueAppColor),
                              ),
                              // Correct answer display (only after an option is selected)
                              if (cubit.isPressed)
                                Padding(
                                  padding: EdgeInsets.only(top: 8.h),
                                  child: Text(
                                    'Correct Answer: ${cubit.currentQuestions[cubit.index].answer}',
                                    style: GoogleFonts.anton(fontSize: 26.sp, color: Colors.green),
                                  ),
                                ),
                              const Spacer(),
                              // Next button
                              ElevatedButtonCustom(
                                onPressed: () {
                                  cubit.nextQuestion();
                                },
                                buttonLabel: cubit.index < cubit.currentQuestions.length - 1 ? 'Next Question' : 'Finish',
                              ),
                              SizedBox(height: 16.h),
                            ],
                          ),
                        )
                      else
                        Center(child: Text('No questions available', style: GoogleFonts.anton(fontSize: 16.sp))),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}