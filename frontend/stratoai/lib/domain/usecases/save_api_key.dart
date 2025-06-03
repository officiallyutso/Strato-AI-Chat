import '../entities/api_key.dart';
import '../repositories/api_key_repository.dart';

class SaveApiKey {
  final ApiKeyRepository repository;

  SaveApiKey(this.repository);

  Future<ApiKey> call(ApiKey apiKey) async {
    return await repository.saveApiKey(apiKey);
  }
}