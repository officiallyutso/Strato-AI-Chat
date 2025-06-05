import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_model_usecases.dart';
import '../../../domain/entities/llm_provider.dart';
import 'models_state.dart';

class ModelsCubit extends Cubit<ModelsState> {
  final GetModelsUsecase getModelsUsecase;

  ModelsCubit({required this.getModelsUsecase}) : super(ModelsInitial());

  Future<void> loadModels() async {
    emit(ModelsLoading());
    try {
      final models = await getModelsUsecase();
      emit(ModelsLoaded(models));
    } catch (e) {
      emit(ModelsError(e.toString()));
    }
  }

  void toggleModelSelection(LlmProvider model) {
    if (state is ModelsLoaded) {
      final currentState = state as ModelsLoaded;
      final selectedModels = List<LlmProvider>.from(currentState.selectedModels);
      
      if (selectedModels.contains(model)) {
        selectedModels.remove(model);
      } else {
        selectedModels.add(model);
      }
      
      emit(ModelsLoaded(currentState.models, selectedModels: selectedModels));
    }
  }

  void clearSelection() {
    if (state is ModelsLoaded) {
      final currentState = state as ModelsLoaded;
      emit(ModelsLoaded(currentState.models));
    }
  }
}