import '../entities/chat.dart';

abstract class ChatRepository {
  Future<Chat> sendPrompt(String prompt, List<String> providers, String userId);
  Future<List<Chat>> getUserChats(String userId);
  Future<Chat> getChat(String chatId);
  Future<Chat> selectResponse(String chatId, String responseId);
}