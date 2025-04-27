import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Domain/Repo/VoiceAnalysisRepo.dart';
class VoiceCubit extends Cubit<VoiceState> {
  final VoiceAnalysisRepository _repository;
  VoiceCubit(this._repository) : super(VoiceInitial());

  Future<void> analyzeVoice(String filePath) async {
    print("analyzing file $filePath");
    emit(VoiceLoading());
    try {
      final result = await _repository.analyzeAudio(filePath);
      print("API Response: $result");  // 🔹 Debug log
      emit(VoiceSuccess(result));
    } catch (e) {
      print("Error: ${e.toString()}");  // 🔹 Debug log
      emit(VoiceError("Error: ${e.toString()}"));
    }
  }
}

abstract class VoiceState {}

class VoiceInitial extends VoiceState {}

class VoiceLoading extends VoiceState {}

class VoiceSuccess extends VoiceState {
  final Map<String, dynamic> response;
  VoiceSuccess(this.response);
}

class VoiceError extends VoiceState {
  final String message;
  VoiceError(this.message);
}
