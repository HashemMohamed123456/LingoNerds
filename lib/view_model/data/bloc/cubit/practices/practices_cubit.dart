// cubit/practices_cubit.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingonerds/core/themes/app_themes.dart';
import 'package:lingonerds/model/practice/practice_model.dart';
import 'package:meta/meta.dart';

import '../../../../../core/firebase/firestore_handler.dart';

part 'practices_state.dart';

class PracticesCubit extends Cubit<PracticesState> {
  PracticesCubit() : super(PracticesInitial()) {
    // Preload both question sets at initialization
    loadAllQuestions();
  }

  static PracticesCubit get(context) => BlocProvider.of<PracticesCubit>(context);

  int score = 0;
  int index = 0;
  bool isPressed = false;
  bool isAlreadySelected = false;
  String selectedLevel = 'A1';
  String practiceType = 'Vocabulary Levels'; // Default practice type
  List<String> levelsList = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
  List<Question> currentQuestions = [];
  LevelQuestions? vocabLevelQuestions;
  LevelQuestions? grammarLevelQuestions;
  String? userLanguageLevel;

  Future<void> loadAllQuestions() async {
    try {
      emit(QuestionsLoadingState());
      // Load vocabulary questions if not already loaded
      if (vocabLevelQuestions == null) {
        final String vocabQuestionsPath = await rootBundle.loadString('assets/files/english_vocabulary_mcq_questions.json');
        final Map<String, dynamic> vocabQuestionsJsonData = jsonDecode(vocabQuestionsPath);
        vocabLevelQuestions = LevelQuestions.fromJson(vocabQuestionsJsonData);
      }
      // Load grammar questions if not already loaded
      if (grammarLevelQuestions == null) {
        final String grammarQuestionsPath = await rootBundle.loadString('assets/files/english_grammar_mcq_questions.json');
        final Map<String, dynamic> grammarQuestionsJsonData = jsonDecode(grammarQuestionsPath);
        grammarLevelQuestions = LevelQuestions.fromJson(grammarQuestionsJsonData);
      }
      currentQuestions = getQuestionsByLevel(selectedLevel);
      final levelQuestions = getCurrentLevelQuestions();
      if (levelQuestions != null) {
        emit(QuestionsLoadingSuccessState(levelQuestions));
      } else {
        emit(QuestionsNotLoadedState('$practiceType questions not loaded'));
      }
    } catch (e) {
      emit(QuestionsLoadingErrorState(e.toString()));
    }
  }

  Future<void> loadQuestions() async {
    try {
      emit(QuestionsLoadingState());
      if (practiceType == 'Vocabulary Levels' && vocabLevelQuestions == null) {
        final String vocabQuestionsPath = await rootBundle.loadString('assets/files/english_vocabulary_mcq_questions.json');
        final Map<String, dynamic> vocabQuestionsJsonData = jsonDecode(vocabQuestionsPath);
        vocabLevelQuestions = LevelQuestions.fromJson(vocabQuestionsJsonData);
      } else if (practiceType == 'Grammar Levels' && grammarLevelQuestions == null) {
        final String grammarQuestionsPath = await rootBundle.loadString('assets/files/english_grammar_mcq_questions.json');
        final Map<String, dynamic> grammarQuestionsJsonData = jsonDecode(grammarQuestionsPath);
        grammarLevelQuestions = LevelQuestions.fromJson(grammarQuestionsJsonData);
      }
      currentQuestions = getQuestionsByLevel(selectedLevel);
      final levelQuestions = getCurrentLevelQuestions();
      if (levelQuestions != null) {
        emit(QuestionsLoadingSuccessState(levelQuestions));
      } else {
        emit(QuestionsNotLoadedState('$practiceType questions not loaded'));
      }
    } catch (e) {
      emit(QuestionsLoadingErrorState(e.toString()));
    }
  }

  LevelQuestions? getCurrentLevelQuestions() {
    if (practiceType == 'Vocabulary Levels') {
      if (vocabLevelQuestions == null) {
        emit(QuestionsNotLoadedState('Vocabulary questions not loaded'));
        return null;
      }
      return vocabLevelQuestions;
    } else {
      if (grammarLevelQuestions == null) {
        emit(QuestionsNotLoadedState('Grammar questions not loaded'));
        return null;
      }
      return grammarLevelQuestions;
    }
  }

  List<Question> getQuestionsByLevel(String level) {
    final levelQuestions = getCurrentLevelQuestions();
    if (levelQuestions == null) {
      return [];
    }
    switch (level.toUpperCase()) {
      case 'A1':
        return levelQuestions.a1;
      case 'A2':
        return levelQuestions.a2;
      case 'B1':
        return levelQuestions.b1;
      case 'B2':
        return levelQuestions.b2;
      case 'C1':
        return levelQuestions.c1;
      case 'C2':
        return levelQuestions.c2;
      default:
        return [];
    }
  }

  Future<void> fetchUserLevel(String userId) async {
    try {
      emit(UserLevelLoadingState());
      final user = await FireStoreHandler.getUser(userId);
      userLanguageLevel = user?.languageLevel ?? 'A1'; // Default to A1 if null
      filterLevelsList();
      emit(UserLevelLoadedState(userLanguageLevel!));
    } catch (e) {
      emit(UserLevelErrorState(e.toString()));
    }
  }

  void filterLevelsList() {
    const levelHierarchy = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
    if (userLanguageLevel != null) {
      final userLevelIndex = levelHierarchy.indexOf(userLanguageLevel!);
      if (userLevelIndex >= 0) {
        levelsList = levelHierarchy.sublist(0, userLevelIndex + 1);
      } else {
        levelsList = ['A1']; // Fallback to A1 if level is invalid
      }
    } else {
      levelsList = ['A1']; // Fallback if no level is set
    }
    // Ensure selectedLevel is valid
    if (!levelsList.contains(selectedLevel)) {
      selectedLevel = levelsList.first;
    }
  }

  Future<void> selectLevel(String level, String newPracticeType) async {
    if (levelsList.contains(level)) {
      emit(QuestionsLoadingState());
      if (practiceType != newPracticeType) {
        practiceType = newPracticeType;
        await loadQuestions();
      }
      selectedLevel = level;
      currentQuestions = getQuestionsByLevel(level);
      score = 0;
      index = 0;
      isPressed = false;
      isAlreadySelected = false;
      final levelQuestions = getCurrentLevelQuestions();
      if (levelQuestions != null) {
        emit(QuestionsLoadingSuccessState(levelQuestions));
      } else {
        emit(QuestionsNotLoadedState('$newPracticeType questions not loaded'));
      }
    }
  }

  void checkAnswerAndUpdate(Question question, int selectedIndex) {
    if (isAlreadySelected) {
      emit(AlreadySelectedAnswerState());
      return;
    }

    final levelQuestions = getCurrentLevelQuestions();
    if (levelQuestions == null) {
      emit(QuestionsNotLoadedState('$practiceType questions not loaded'));
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
      score,
      levelQuestions,
    ));
  }

  Future<void> startOver() async {
    emit(StartOverLoadingState());
    index = 0;
    score = 0;
    isPressed = false;
    isAlreadySelected = false;
    currentQuestions = getQuestionsByLevel(selectedLevel);
    final levelQuestions = getCurrentLevelQuestions();
    if (levelQuestions != null) {
      emit(StartOverSuccessState(levelQuestions));
    } else {
      emit(QuestionsNotLoadedState('$practiceType questions not loaded'));
    }
  }

  void nextQuestion() {
    if (isPressed) {
      if (index < currentQuestions.length - 1) {
        index++;
        isPressed = false;
        isAlreadySelected = false;
        final levelQuestions = getCurrentLevelQuestions();
        if (levelQuestions != null) {
          emit(NextQuestionSuccessState(levelQuestions));
        } else {
          emit(QuestionsNotLoadedState('$practiceType questions not loaded'));
        }
      } else {
        emit(QuizCompletedState(score, currentQuestions.length));
      }
    } else {
      emit(AnswerNotSelectedState());
    }
  }

  Color getOptionColor(int index, PracticesState state) {
    if (state is AnswerCheckedState) {
      return index == state.selectedIndex
          ? (state.isCorrect ? Colors.green : Colors.red)
          : AppThemes.blueAppColor;
    }
    return AppThemes.blueAppColor;
  }
}