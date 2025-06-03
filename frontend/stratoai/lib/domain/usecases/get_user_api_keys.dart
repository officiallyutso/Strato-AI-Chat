import '../entities/api_key.dart';
import '../repositories/api_key_repository.dart';

class GetUserApiKeys {
  final ApiKeyRepository repository;

  GetUserApiKeys(this.repository);

  Future<List<ApiKey>> call(String userId) async {
    return await repository.getUserApiKeys(userId);
  }
}