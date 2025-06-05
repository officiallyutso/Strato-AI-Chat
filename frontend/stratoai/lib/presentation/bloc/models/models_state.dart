import '../../../domain/entities/llm_provider.dart';

abstract class ModelsState {}

class ModelsInitial extends ModelsState {}
class ModelsLoading extends ModelsState {}
class ModelsLoaded extends ModelsState {
  final List<LlmProvider> models;
  final List<LlmProvider> selectedModels;
  
  ModelsLoaded(this.models, {this.selectedModels = const []});
}
class ModelsError extends ModelsState {
  final String message;
  ModelsError(this.message);
}