part of 'vocabulary_tests_cubit.dart';

@immutable
abstract class TestsState {}

class TestsInitial extends TestsState {}

class UserDataFetchingLoadingState extends TestsState {}

class UserDataFetchingSuccessState extends TestsState {}

class UserDataFetchingErrorState extends TestsState {}

class ExamDataLoadingState extends TestsState {}

class ExamDataLoadingSuccessState extends TestsState {}

class ExamDataLoadingErrorState extends TestsState {
  final String error;
  ExamDataLoadingErrorState({required this.error});
}

class AlreadySelectedAnswerState extends TestsState {}

class SelectionSuccessState extends TestsState {}

class TrueAnswerState extends TestsState {}

class StartOverSuccessState extends TestsState {}

class StartOverLoadingState extends TestsState {}

class AnswerSelectedState extends TestsState {}

class AnswerNotSelectedState extends TestsState {}

class CorrectAnswerColorState extends TestsState {}

class IncorrectAnswerColorState extends TestsState {}

class NextQuestionSuccessState extends TestsState {}

class IncreasingScoreSuccessState extends TestsState {}

class AnswerCheckedState extends TestsState {
  final bool isCorrect;
  final int selectedIndex;
  final int newScore;
  AnswerCheckedState(this.isCorrect, this.selectedIndex, this.newScore);
}

class LevelUpdatedState extends TestsState {
  final String newLevel;
  LevelUpdatedState(this.newLevel);
}

class LevelUpdateErrorState extends TestsState {
  final String error;
  LevelUpdateErrorState(this.error);
}

class TestCompletedState extends TestsState {
  final int score;
  final int totalQuestions;
  TestCompletedState(this.score, this.totalQuestions);
}

class UpdatingUserLevelLoadingState extends TestsState {}

class LastLevelC2State extends TestsState {}