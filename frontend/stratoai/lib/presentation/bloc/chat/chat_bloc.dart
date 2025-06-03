import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/chat.dart';
import '../../../domain/usecases/send_prompt.dart';
import '../../../domain/usecases/get_user_chats.dart';
import '../../../domain/usecases/get_chat.dart';
import '../../../domain/usecases/select_response.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendPrompt sendPrompt;
  final GetUserChats getUserChats;
  final GetChat getChat;
  final SelectResponse selectResponse;

  ChatBloc({
    required this.sendPrompt,
    required this.getUserChats,
    required this.getChat,
    required this.selectResponse,
  }) : super(ChatInitial()) {
    on<SendPromptEvent>(_onSendPrompt);
    on<GetUserChatsEvent>(_onGetUserChats);
    on<GetChatEvent>(_onGetChat);
    on<SelectResponseEvent>(_onSelectResponse);
  }

  Future<void> _onSendPrompt(SendPromptEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final chat = await sendPrompt(event.prompt, event.providers, event.userId);
      emit(ChatLoaded(chat));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onGetUserChats(GetUserChatsEvent event, Emitter<ChatState> emit) async {
    emit(ChatHistoryLoading());
    try {
      final chats = await getUserChats(event.userId);
      emit(ChatHistoryLoaded(chats));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onGetChat(GetChatEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final chat = await getChat(event.chatId);
      emit(ChatLoaded(chat));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onSelectResponse(SelectResponseEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final chat = await selectResponse(event.chatId, event.responseId);
      emit(ChatLoaded(chat));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}