import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingonerds/core/themes/app_themes.dart';
import 'package:meta/meta.dart';
import '../../../../../core/firebase/firestore_handler.dart';
import '../../../../../model/exams/exams_data_model.dart';
import '../../../../../view_model/data/bloc/cubit/auth/auth_cubit.dart';
part 'vocabulary_tests_state.dart';

class TestsCubit extends Cubit<TestsState> {
  TestsCubit() : super(TestsInitial());
  static TestsCubit get(context) => BlocProvider.of<TestsCubit>(context);
  String? userName;
  String? level;
  ExamData? examData;
  int score = 0;
  int index = 0;
  int currentQuestionIndex = 0;
  bool isPressed = false;
  bool isAlreadySelected = false;
  List<Question>? questions;

  Future<void> fetchUserData() async {
    emit(UserDataFetchingLoadingState());
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      userName = await FireStoreHandler.getUserField<String>(uid, "Name");
      level = await FireStoreHandler.getUserField<String>(uid, "LanguageLevel");
      debugPrint("TestsCubit: Fetched user data - Name: $userName, Level: $level");
      emit(UserDataFetchingSuccessState());
    } catch (e) {
      debugPrint("TestsCubit: Error fetching user data: $e");
      emit(UserDataFetchingErrorState());
    }
  }

  Future<void> loadExamData() async {
    emit(ExamDataLoadingState());
    try {
      final jsonString = await rootBundle.loadString('assets/files/mixed_20_questions_per_level.json');
      if (jsonString.trim().isEmpty) {
        throw Exception("Exam JSON file is empty!");
      }
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      examData = ExamData.fromJson(jsonMap);
      debugPrint("TestsCubit: Loaded exam data successfully");
      emit(ExamDataLoadingSuccessState());
    } catch (e) {
      debugPrint("TestsCubit: Error loading exam data: $e");
      emit(ExamDataLoadingErrorState(error: e.toString()));
    }
  }

  List<Question> getLevelQuestions() {
    if (level == null || examData == null) return [];
    return examData!.exams[level!]?.questions.values.toList() ?? [];
  }

  void checkAnswerAndUpdate(Question question, int selectedIndex) {
    if (isAlreadySelected) {
      emit(AlreadySelectedAnswerState());
      return;
    }
    final isCorrect = question.options[selectedIndex] == question.answer;
    if (isCorrect) {
      score++;
    }
    isAlreadySelected = true;
    isPressed = true;
    debugPrint("TestsCubit: Answer checked - Correct: $isCorrect, Score: $score");
    emit(AnswerCheckedState(isCorrect, selectedIndex, score));
  }

  Future<void> startOver() async {
    emit(StartOverLoadingState());
    index = 0;
    score = 0;
    isPressed = false;
    isAlreadySelected = false;
    debugPrint("TestsCubit: Test started over");
    emit(StartOverSuccessState());
  }

  void nextQuestion() {
    if (isPressed) {
      index++;
      isPressed = false;
      isAlreadySelected = false;
      debugPrint("TestsCubit: Moved to next question, index: $index");
      emit(NextQuestionSuccessState());
    } else {
      emit(AnswerNotSelectedState());
    }
  }

  Color getOptionColor(int index, TestsState state) {
    if (state is AnswerCheckedState) {
      return index == state.selectedIndex
          ? (state.isCorrect ? Colors.green : Colors.red)
          : AppThemes.blueAppColor;
    }
    return AppThemes.blueAppColor;
  }

  Future<void> updateUserLevel(BuildContext context) async {
    emit(UpdatingUserLevelLoadingState());
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        debugPrint("TestsCubit: Error - User not logged in");
        emit(LevelUpdateErrorState("User not logged in"));
        return;
      }
      final currentLevel = level;
      if (currentLevel == null) {
        debugPrint("TestsCubit: Error - Current level not set");
        emit(LevelUpdateErrorState("Current level not set"));
        return;
      }
      final nextLevel = getNextLevel(currentLevel);
      await FireStoreHandler.updateLanguageLevel(userId, nextLevel);
      debugPrint("TestsCubit: Updated Firestore level to $nextLevel");
      // Update local state
      level = nextLevel;
      score = 0;
      index = 0;
      // Notify AuthCubit to reload user data
      final authCubit = context.read<AuthCubit>();
      await authCubit.loadUserData();
      debugPrint("TestsCubit: Triggered AuthCubit.loadUserData");
      emit(LevelUpdatedState(nextLevel));
    } catch (e) {
      debugPrint("TestsCubit: Error updating level: $e");
      emit(LevelUpdateErrorState(e.toString()));
    }
  }

  String getNextLevel(String currentLevel) {
    final levels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
    final currentIndex = levels.indexOf(currentLevel);
    if (currentIndex == levels.length - 1) {
      debugPrint("TestsCubit: At max level C2");
      emit(LastLevelC2State());
      return currentLevel;
    }
    debugPrint("TestsCubit: Next level from $currentLevel to ${levels[currentIndex + 1]}");
    return levels[currentIndex + 1];
  }

  Future<void> completeTest(List<Question> questions, BuildContext context) async {
    final passingScore = questions.length * 0.6;
    debugPrint("TestsCubit: Completing test - Score: $score, Passing: $passingScore");
    if (score >= passingScore) {
      await updateUserLevel(context);
    }
    emit(TestCompletedState(score, questions.length));
  }

  bool validateAnswerSelection() {
    if (!isPressed) {
      emit(AnswerNotSelectedState());
      return false;
    }
    return true;
  }
}