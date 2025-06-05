import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_chat.dart';
import '../../../domain/usecases/send_prompt.dart';
import '../../../domain/entities/chat.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final GetChat getChatsUsecase;
  final SendPrompt sendPromptUsecase;

  ChatCubit({
    required this.getChatsUsecase,
    required this.sendPromptUsecase,
  }) : super(ChatInitial());

  Future<void> loadChats(String userId) async {
    emit(ChatLoading());
    try {
      final chats = await getChatsUsecase(userId);
      emit(ChatsLoaded(chats as List<Chat>));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> sendMessage(String prompt, List<String> modelIds, String userId) async {
    emit(MessageSending());
    try {
      final chat = await sendPromptUsecase(prompt, modelIds, userId);
      emit(MessageSent(chat));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> continueChat(String chatId, String prompt, List<String> modelIds, String userId) async {
    emit(MessageSending());
    try {
      // For continuing chat, we'll need to modify the usecase to accept chatId
      final chat = await sendPromptUsecase(prompt, modelIds, userId);
      emit(MessageSent(chat));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}