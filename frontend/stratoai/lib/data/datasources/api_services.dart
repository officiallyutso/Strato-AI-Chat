import 'package:dio/dio.dart' hide Response;
import 'package:stratoai/data/models/chat_model.dart';
import 'package:stratoai/data/models/llm_provider_model.dart';

class ApiService {
  static const String baseUrl = 'https://gostratoaibackend.arjosarkar.repl.co/'; ///backend hosted base url repl it meh
  
  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  ApiService() {
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print(obj),
    ));
  }

  // Health check
  Future<bool> ping() async {
    try {
      final response = await _dio.get('/ping');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Get available models
  Future<List<LLMModel>> getModels() async {
    try {
      final response = await _dio.get('/models');
      final List<dynamic> data = response.data;
      return data.map((json) => LLMModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch models: $e');
    }
  }

  // Send prompt to multiple models
  Future<PromptResponse> sendPrompt({
    required String userId,
    String? chatId,
    required String prompt,
    required List<String> modelIds,
  }) async {
    try {
      final response = await _dio.post('/prompt', data: {
        'user_id': userId,
        if (chatId != null) 'chat_id': chatId,
        'prompt': prompt,
        'model_ids': modelIds,
      });
      
      return PromptResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to send prompt: $e');
    }
  }

  // Get user chats
  Future<List<Chat>> getUserChats(String userId) async {
    try {
      final response = await _dio.get('/chats/$userId');
      final List<dynamic> data = response.data;
      return data.map((json) => Chat.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch chats: $e');
    }
  }

  // Get specific chat
  Future<Chat> getChat(String chatId) async {
    try {
      final response = await _dio.get('/chat/$chatId');
      return Chat.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch chat: $e');
    }
  }

  // Save API key
  Future<APIKey> saveApiKey(APIKey apiKey) async {
    try {
      final response = await _dio.post('/apikey', data: apiKey.toJson());
      return APIKey.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to save API key: $e');
    }
  }

  // Get user API keys
  Future<List<APIKey>> getUserApiKeys(String userId) async {
    try {
      final response = await _dio.get('/apikeys/$userId');
      final List<dynamic> data = response.data;
      return data.map((json) => APIKey.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch API keys: $e');
    }
  }
}

class PromptResponse {
  final String chatId;
  final String messageId;
  final List<Response> responses;

  PromptResponse({
    required this.chatId,
    required this.messageId,
    required this.responses,
  });

  factory PromptResponse.fromJson(Map<String, dynamic> json) {
    return PromptResponse(
      chatId: json['chat_id'],
      messageId: json['message_id'],
      responses: (json['responses'] as List<dynamic>)
          .map((e) => Response.fromJson(e))
          .toList(),
    );
  }
}