import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

class SelectResponse {
  final ChatRepository repository;

  SelectResponse(this.repository);

  Future<Chat> call(String chatId, String responseId) async {
    return await repository.selectResponse(chatId, responseId);
  }
}