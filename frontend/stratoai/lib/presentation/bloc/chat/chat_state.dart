import '../../../domain/entities/chat.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}
class ChatLoading extends ChatState {}
class ChatsLoaded extends ChatState {
  final List<Chat> chats;
  ChatsLoaded(this.chats);
}
class ChatLoaded extends ChatState {
  final Chat chat;
  ChatLoaded(this.chat);
}
class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}
class MessageSending extends ChatState {}
class MessageSent extends ChatState {
  final Chat updatedChat;
  MessageSent(this.updatedChat);
}