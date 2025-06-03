import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/api_key.dart';
import '../../../domain/usecases/save_api_key.dart';
import '../../../domain/usecases/get_user_api_keys.dart';

part 'api_key_state.dart';

class ApiKeyCubit extends Cubit<ApiKeyState> {
  final SaveApiKey saveApiKey;
  final GetUserApiKeys getUserApiKeys;

  ApiKeyCubit({
    required this.saveApiKey,
    required this.getUserApiKeys,
  }) : super(ApiKeyInitial());

  Future<void> saveKey(ApiKey apiKey) async {
    emit(ApiKeySaving());
    try {
      await saveApiKey(apiKey);
      final keys = await getUserApiKeys(apiKey.userId);
      emit(ApiKeysLoaded(keys));
    } catch (e) {
      emit(ApiKeyError(e.toString()));
    }
  }

  Future<void> loadUserKeys(String userId) async {
    emit(ApiKeyLoading());
    try {
      final keys = await getUserApiKeys(userId);
      emit(ApiKeysLoaded(keys));
    } catch (e) {
      emit(ApiKeyError(e.toString()));
    }
  }
}