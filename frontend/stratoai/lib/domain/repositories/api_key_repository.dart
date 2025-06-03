import '../entities/api_key.dart';

abstract class ApiKeyRepository {
  Future<ApiKey> saveApiKey(ApiKey apiKey);
  Future<List<ApiKey>> getUserApiKeys(String userId);
}