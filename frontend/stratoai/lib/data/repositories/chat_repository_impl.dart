import '../../domain/entities/chat.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Chat> sendPrompt(String prompt, List<String> providers, String userId) async {
    return await remoteDataSource.sendPrompt(prompt, providers, userId);
  }

  @override
  Future<List<Chat>> getUserChats(String userId) async {
    return await remoteDataSource.getUserChats(userId);
  }

  @override
  Future<Chat> getChat(String chatId) async {
    return await remoteDataSource.getChat(chatId);
  }

  @override
  Future<Chat> selectResponse(String chatId, String responseId) async {
    return await remoteDataSource.selectResponse(chatId, responseId);
  }
}