import '../entities/llm_provider.dart';
import '../repositories/llm_provider_repository.dart';

class GetProviders {
  final LlmProviderRepository repository;

  GetProviders(this.repository);

  Future<List<LlmProvider>> call() async {
    return await repository.getProviders();
  }
}