import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

class GetUserChats {
  final ChatRepository repository;

  GetUserChats(this.repository);

  Future<List<Chat>> call(String userId) async {
    return await repository.getUserChats(userId);
  }
}