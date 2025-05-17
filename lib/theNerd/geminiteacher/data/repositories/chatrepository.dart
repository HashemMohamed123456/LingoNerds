import '../../domain/entities/chat_response.dart';

abstract class ChatRepository {
  Future<ChatResponse> sendInput(String inputText);
}