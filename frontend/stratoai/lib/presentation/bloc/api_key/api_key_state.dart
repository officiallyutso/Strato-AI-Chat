part of 'api_key_cubit.dart';

abstract class ApiKeyState extends Equatable {
  const ApiKeyState();

  @override
  List<Object> get props => [];
}

class ApiKeyInitial extends ApiKeyState {}

class ApiKeyLoading extends ApiKeyState {}

class ApiKeySaving extends ApiKeyState {}

class ApiKeysLoaded extends ApiKeyState {
  final List<ApiKey> keys;

  const ApiKeysLoaded(this.keys);

  @override
  List<Object> get props => [keys];
}

class ApiKeyError extends ApiKeyState {
  final String message;

  const ApiKeyError(this.message);

  @override
  List<Object> get props => [message];
}