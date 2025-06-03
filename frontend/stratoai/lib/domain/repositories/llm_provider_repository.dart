import '../entities/llm_provider.dart';

abstract class LlmProviderRepository {
  Future<List<LlmProvider>> getProviders();
}