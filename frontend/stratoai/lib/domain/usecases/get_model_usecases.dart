import '../entities/llm_provider.dart';
import '../repositories/llm_provider_repository.dart';

class GetModelsUsecase {
  final LlmProviderRepository repository;

  GetModelsUsecase(this.repository);

  Future<List<LlmProvider>> call() async {
    return await repository.getProviders();
  }
}