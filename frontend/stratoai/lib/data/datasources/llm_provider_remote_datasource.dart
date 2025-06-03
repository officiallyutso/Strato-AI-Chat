import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/llm_provider_model.dart';

class LlmProviderRemoteDataSource {
  final String baseUrl;
  final http.Client client;

  LlmProviderRemoteDataSource({required this.baseUrl, required this.client});

  Future<List<LlmProviderModel>> getProviders() async {
    final response = await client.get(
      Uri.parse('$baseUrl/providers'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((json) => LlmProviderModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get providers');
    }
  }
}