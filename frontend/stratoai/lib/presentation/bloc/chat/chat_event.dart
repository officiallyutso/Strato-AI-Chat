part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class SendPromptEvent extends ChatEvent {
  final String prompt;
  final List<String> providers;
  final String userId;

  const SendPromptEvent({
    required this.prompt,
    required this.providers,
    required this.userId,
  });

  @override
  List<Object> get props => [prompt, providers, userId];
}

class GetUserChatsEvent extends ChatEvent {
  final String userId;

  const GetUserChatsEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

class GetChatEvent extends ChatEvent {
  final String chatId;

  const GetChatEvent(this.chatId);

  @override
  List<Object> get props => [chatId];
}

class SelectResponseEvent extends ChatEvent {
  final String chatId;
  final String responseId;

  const SelectResponseEvent({
    required this.chatId,
    required this.responseId,
  });

  @override
  List<Object> get props => [chatId, responseId];
}