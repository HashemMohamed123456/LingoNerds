part of 'practices_cubit.dart';

@immutable
abstract class PracticesState {}

class PracticesInitial extends PracticesState {}

class QuestionsLoadingState extends PracticesState {}

class QuestionsLoadingSuccessState extends PracticesState {
  final LevelQuestions levelQuestions;
  QuestionsLoadingSuccessState(this.levelQuestions);
}

class QuestionsLoadingErrorState extends PracticesState {
  final String error;
  QuestionsLoadingErrorState(this.error);
}

class QuestionsNotLoadedState extends PracticesState {
  final String message;
  QuestionsNotLoadedState(this.message);
}

class UserLevelLoadingState extends PracticesState {}

class UserLevelLoadedState extends PracticesState {
  final String userLevel;
  UserLevelLoadedState(this.userLevel);
}

class UserLevelErrorState extends PracticesState {
  final String error;
  UserLevelErrorState(this.error);
}

class AnswerCheckedState extends PracticesState {
  final bool isCorrect;
  final int selectedIndex;
  final int score;
  final LevelQuestions levelQuestions;
  AnswerCheckedState(this.isCorrect, this.selectedIndex, this.score, this.levelQuestions);
}

class AlreadySelectedAnswerState extends PracticesState {}

class AnswerNotSelectedState extends PracticesState {}

class StartOverLoadingState extends PracticesState {}

class StartOverSuccessState extends PracticesState {
  final LevelQuestions levelQuestions;
  StartOverSuccessState(this.levelQuestions);
}

class NextQuestionSuccessState extends PracticesState {
  final LevelQuestions levelQuestions;
  NextQuestionSuccessState(this.levelQuestions);
}

class QuizCompletedState extends PracticesState {
  final int score;
  final int totalQuestions;
  QuizCompletedState(this.score, this.totalQuestions);
}