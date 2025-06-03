import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

class SendPrompt {
  final ChatRepository repository;

  SendPrompt(this.repository);

  Future<Chat> call(String prompt, List<String> providers, String userId) async {
    return await repository.sendPrompt(prompt, providers, userId);
  }
}