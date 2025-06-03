import '../../domain/entities/llm_provider.dart';
import '../../domain/repositories/llm_provider_repository.dart';
import '../datasources/llm_provider_remote_datasource.dart';

class LlmProviderRepositoryImpl implements LlmProviderRepository {
  final LlmProviderRemoteDataSource remoteDataSource;

  LlmProviderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<LlmProvider>> getProviders() async {
    return await remoteDataSource.getProviders();
  }
}