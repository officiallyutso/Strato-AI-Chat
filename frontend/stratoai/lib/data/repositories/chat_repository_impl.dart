import 'dart:async';

import '../../domain/entities/chat.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Chat> sendPrompt(String prompt, List<String> providers, String userId) {
    final result = remoteDataSource.sendPrompt(prompt, providers, userId);
    return Future.value(result as FutureOr<Chat>?);
  }

  @override
  Future<List<Chat>> getUserChats(String userId) {
    final result = remoteDataSource.getUserChats(userId);
    return Future.value(result as FutureOr<List<Chat>>?);
  }

  @override
  Future<Chat> getChat(String chatId) {
    final result = remoteDataSource.getChat(chatId);
    return Future.value(result as FutureOr<Chat>?);
  }

  @override
  Future<Chat> selectResponse(String chatId, String responseId) {
    final result = remoteDataSource.selectResponse(chatId, responseId);
    return Future.value(result as FutureOr<Chat>?);
  }
}
