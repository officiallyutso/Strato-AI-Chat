import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/llm_provider.dart';
import '../../../domain/usecases/get_providers.dart';

part 'provider_state.dart';

class ProviderCubit extends Cubit<ProviderState> {
  final GetProviders getProviders;

  ProviderCubit({required this.getProviders}) : super(ProviderInitial());

  Future<void> loadProviders() async {
    emit(ProviderLoading());
    try {
      final providers = await getProviders();
      emit(ProvidersLoaded(providers));
    } catch (e) {
      emit(ProviderError(e.toString()));
    }
  }
}