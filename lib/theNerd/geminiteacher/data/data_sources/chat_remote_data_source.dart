import '../../domain/entities/chat_response.dart';

abstract class ChatRemoteDataSource {
  Future<ChatResponse> sendMessage(String inputText);
}