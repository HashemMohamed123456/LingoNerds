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
part 'vocabulary_tests_state.dart';
class TestsCubit extends Cubit<TestsState> {
  TestsCubit() : super(TestsInitial());
  static TestsCubit get(context)=>BlocProvider.of<TestsCubit>(context);
  String? userName;
  String? level;
  ExamData? examData;
  int score = 0;
  int index=0;
  int currentQuestionIndex = 0;
  bool isPressed=false;
  bool isAlreadySelected=false;
  List<Question>? questions;
  Future<void> fetchUserData() async {
    emit(UserDataFetchingLoadingState());
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      userName = await FireStoreHandler.getUserField<String>(uid, "Name");
      level = await FireStoreHandler.getUserField<String>(uid, "LanguageLevel");
      emit(UserDataFetchingSuccessState());
    } catch (e) {
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

      final jsonMap = json.decode(jsonString) as Map<String, dynamic>; // Explicit cast
      examData = ExamData.fromJson(jsonMap);
      emit(ExamDataLoadingSuccessState());
    } catch (e) {
      print("Error loading exam data: $e");
      emit(ExamDataLoadingErrorState(error: e.toString())); // Add error message to state
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
    emit(AnswerCheckedState(
      isCorrect,
      selectedIndex,
      score, // Pass the updated score
    ));
  }
  Future<void> startOver() async{
    emit(StartOverLoadingState());
    index = 0;
    score = 0;
    isPressed = false;
    isAlreadySelected = false;
    emit(StartOverSuccessState());
  }
  void nextQuestion(){
    if(isPressed){
      index++;
      isPressed=false;
      isAlreadySelected=false;
      emit(NextQuestionSuccessState());
    }else{
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
  Future<void> updateUserLevel() async {
    emit(UpdatingUserLevelLoadingState());
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      final currentLevel = level;
      if (currentLevel == null) return;

      // Determine next level
      final nextLevel = getNextLevel(currentLevel);

      // Update in Firestore
      await FireStoreHandler.updateLanguageLevel(userId, nextLevel);

      // Update local state
      level = nextLevel;
      score=0;
      emit(LevelUpdatedState(nextLevel));

    } catch (e) {
      emit(LevelUpdateErrorState(e.toString()));
    }
  }
  String getNextLevel(String currentLevel) {
    final levels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
    final currentIndex = levels.indexOf(currentLevel);

    // If at highest level, stay there
    if (currentIndex == levels.length - 1) return currentLevel;

    // Otherwise progress to next level
    return levels[currentIndex + 1];
  }

  Future<void> completeTest(List<Question> questions) async {
    final passingScore = questions.length * 0.6; // 60% threshold

    if (score >= passingScore) {
      await updateUserLevel();
    }

    emit(TestCompletedState(score, questions.length));
  }
}
