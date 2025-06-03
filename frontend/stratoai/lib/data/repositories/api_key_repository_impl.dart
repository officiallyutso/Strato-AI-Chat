import '../../domain/entities/api_key.dart';
import '../../domain/repositories/api_key_repository.dart';
import '../datasources/api_key_remote_datasource.dart';
import '../models/api_key_model.dart';

class ApiKeyRepositoryImpl implements ApiKeyRepository {
  final ApiKeyRemoteDataSource remoteDataSource;

  ApiKeyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ApiKey> saveApiKey(ApiKey apiKey) async {
    final apiKeyModel = ApiKeyModel(
      id: apiKey.id,
      userId: apiKey.userId,
      provider: apiKey.provider,
      key: apiKey.key,
      createdAt: apiKey.createdAt,
    );
    return await remoteDataSource.saveApiKey(apiKeyModel);
  }

  @override
  Future<List<ApiKey>> getUserApiKeys(String userId) async {
    return await remoteDataSource.getUserApiKeys(userId);
  }
}