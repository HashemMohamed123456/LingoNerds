import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Repository/fluentme_repository_impl.dart';
import 'fluentMe_states.dart';


// Define Cubit
class FluentMeCubit extends Cubit<FluentMeState> {
  final FluentMeRepository _repository;

  FluentMeCubit({FluentMeRepository? repository})
      : _repository = repository ?? FluentMeRepository(),
        super(FluentMeInitial());

  Future<void> scoreRecording({
    required String audioFilePath,
    String? postId, // Default postId
    int scale = 90, // Default scale
  }) async {
    try {
      emit(FluentMeLoading());

      final response = await _repository.scoreRecording(
        audioFilePath: audioFilePath,
        postId: postId??"P503421720",
        scale: scale,
      );

      emit(FluentMeSuccess(response));
    } catch (e) {
      emit(FluentMeError('Error scoring recording: $e'));
    }
  }
  void resetPronunciationScreen(){
    print('----------------- Reset Pronunciation--------------');
    emit(FluentMeInitial ());
  }
}