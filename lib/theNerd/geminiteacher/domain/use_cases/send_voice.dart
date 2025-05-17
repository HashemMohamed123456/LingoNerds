import 'package:injectable/injectable.dart';

import '../../data/repositories/chatrepository.dart';
import '../entities/chat_response.dart';

@lazySingleton
class SendVoiceInputUseCase {
  final ChatRepository repository;

  SendVoiceInputUseCase(this.repository);

  Future<ChatResponse> call(String inputText) {
    return repository.sendInput(inputText);
  }
}