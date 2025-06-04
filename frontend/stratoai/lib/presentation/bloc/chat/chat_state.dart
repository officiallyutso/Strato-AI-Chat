part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();
  
  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatsLoaded extends ChatState {
  final List<Chat> chats;

  const ChatsLoaded(this.chats);

  @override
  List<Object> get props => [chats];
}
class ChatLoaded extends ChatState {
  final Chat chat;

  const ChatLoaded(this.chat);

  @override
  List<Object> get props => [chat];
}

class ChatHistoryLoading extends ChatState {}

class ChatHistoryLoaded extends ChatState {
  final List<Chat> chats;

  const ChatHistoryLoaded(this.chats);

  @override
  List<Object> get props => [chats];
}
class MessageSending extends ChatState {}

class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object> get props => [message];
}