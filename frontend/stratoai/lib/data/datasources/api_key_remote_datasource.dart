import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_key_model.dart';

class ApiKeyRemoteDataSource {
  final String baseUrl;
  final http.Client client;

  ApiKeyRemoteDataSource({required this.baseUrl, required this.client});

  Future<ApiKeyModel> saveApiKey(ApiKeyModel apiKey) async {
    final response = await client.post(
      Uri.parse('$baseUrl/apikey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(apiKey.toJson()),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ApiKeyModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to save API key');
    }
  }

  Future<List<ApiKeyModel>> getUserApiKeys(String userId) async {
    final response = await client.get(
      Uri.parse('$baseUrl/apikeys/$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((json) => ApiKeyModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get user API keys');
    }
  }
}