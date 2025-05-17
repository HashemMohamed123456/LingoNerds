import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../domain/use_cases/send_voice.dart';
import 'chatstate.dart';

class ChatCubit extends Cubit<ChatState> {
  final SendVoiceInputUseCase sendVoiceInputUseCase;
  final FlutterTts tts;

  ChatCubit(this.sendVoiceInputUseCase, this.tts) : super(ChatInitial());

  Future<void> sendVoiceMessage(String inputText) async {
    emit(ChatLoading());
    try {
      final response = await sendVoiceInputUseCase(inputText);
      await tts.speak(response.reply);
      emit(ChatSuccess(response));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}
