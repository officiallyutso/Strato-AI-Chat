part of 'provider_cubit.dart';

abstract class ProviderState extends Equatable {
  const ProviderState();

  @override
  List<Object> get props => [];
}

class ProviderInitial extends ProviderState {}

class ProviderLoading extends ProviderState {}

class ProvidersLoaded extends ProviderState {
  final List<LlmProvider> providers;

  const ProvidersLoaded(this.providers);

  @override
  List<Object> get props => [providers];
}

class ProviderError extends ProviderState {
  final String message;

  const ProviderError(this.message);

  @override
  List<Object> get props => [message];
}