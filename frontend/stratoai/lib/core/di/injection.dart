import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../../data/datasources/chat_remote_datasource.dart';
import '../../data/datasources/llm_provider_remote_datasource.dart';
import '../../data/datasources/api_key_remote_datasource.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../data/repositories/llm_provider_repository_impl.dart';
import '../../data/repositories/api_key_repository_impl.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/repositories/llm_provider_repository.dart';
import '../../domain/repositories/api_key_repository.dart';
import '../../domain/usecases/get_chat.dart';
import '../../domain/usecases/send_prompt.dart';
import '../../domain/usecases/get_model_usecases.dart';
import '../../domain/usecases/save_api_key.dart';
import '../../presentation/bloc/chat/chat_cubit.dart';
import '../../presentation/bloc/models/models_cubit.dart';
import '../constants/app_constants.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => http.Client());

  // Data sources
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSource(
      baseUrl: AppConstants.baseUrl,
      client: sl(),
    ),
  );

  sl.registerLazySingleton<LlmProviderRemoteDataSource>(
    () => LlmProviderRemoteDataSource(
      baseUrl: AppConstants.baseUrl,
      client: sl(),
    ),
  );

  sl.registerLazySingleton<ApiKeyRemoteDataSource>(
    () => ApiKeyRemoteDataSource(
      baseUrl: AppConstants.baseUrl,
      client: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<LlmProviderRepository>(
    () => LlmProviderRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<ApiKeyRepository>(
    () => ApiKeyRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetChat(sl()));
  sl.registerLazySingleton(() => SendPrompt(sl()));
  sl.registerLazySingleton(() => GetModelsUsecase(sl()));
  sl.registerLazySingleton(() => SaveApiKey(sl()));

  // BLoC
  sl.registerFactory(() => ChatCubit(
    getChatsUsecase: sl(),
    sendPromptUsecase: sl(),
  ));

  sl.registerFactory(() => ModelsCubit(getModelsUsecase: sl()));
}