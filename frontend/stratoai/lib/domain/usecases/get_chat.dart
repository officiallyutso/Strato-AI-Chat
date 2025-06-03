import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

class GetChat {
  final ChatRepository repository;

  GetChat(this.repository);

  Future<Chat> call(String chatId) async {
    return await repository.getChat(chatId);
  }
}