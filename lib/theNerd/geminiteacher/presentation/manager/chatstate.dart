import '../../domain/entities/chat_response.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}
class ChatLoading extends ChatState {}
class ChatSuccess extends ChatState {
  final ChatResponse response;
  ChatSuccess(this.response);
}
class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}
