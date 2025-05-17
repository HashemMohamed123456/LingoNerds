import 'package:injectable/injectable.dart';

import '../../domain/entities/chat_response.dart';
import '../data_sources/chat_remote_data_source.dart';
import 'chatrepository.dart';

@Injectable(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remote;

  ChatRepositoryImpl(this.remote);

  @override
  Future<ChatResponse> sendInput(String inputText) {
    return remote.sendMessage(inputText);
  }
}
