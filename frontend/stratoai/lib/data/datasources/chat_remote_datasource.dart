import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_model.dart';
import '../../domain/entities/chat.dart' hide Chat;

class ChatRemoteDataSource {
  final String baseUrl;
  final http.Client client;

  ChatRemoteDataSource({required this.baseUrl, required this.client});

  Future<Chat> sendPrompt(String prompt, List<String> providers, String userId) async {
    final response = await client.post(
      Uri.parse('$baseUrl/prompt'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'prompt': prompt,
        'model_ids': providers, // Changed from providers to model_ids
        'user_id': userId,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final chatModel = Chat.fromJson(jsonResponse);
      return ChatModelX.fromModel(chatModel);
    } else {
      throw Exception('Failed to send prompt');
    }
  }

  Future<List<Chat>> getUserChats(String userId) async {
    final response = await client.get(
      Uri.parse('$baseUrl/chats/$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse
          .map((json) => ChatModelX.fromModel(Chat.fromJson(json)))
          .toList();
    } else {
      throw Exception('Failed to get user chats');
    }
  }

  Future<Chat> getChat(String chatId) async {
    final response = await client.get(
      Uri.parse('$baseUrl/chat/$chatId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final chatModel = Chat.fromJson(jsonResponse);
      return ChatModelX.fromModel(chatModel);
    } else {
      throw Exception('Failed to get chat');
    }
  }

  Future<Chat> selectResponse(String chatId, String responseId) async {
    final response = await client.put(
      Uri.parse('$baseUrl/chat/$chatId/select/$responseId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final chatModel = Chat.fromJson(jsonResponse);
      return ChatModelX.fromModel(chatModel);
    } else {
      throw Exception('Failed to select response');
    }
  }
}