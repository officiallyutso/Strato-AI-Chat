import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat.g.dart';

@JsonSerializable()
class Chat extends Equatable {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  final String title;
  final List<Message> messages;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @JsonKey(name: 'selected_id')
  final String? selectedId;

  const Chat({
    required this.id,
    required this.userId,
    required this.title,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
    this.selectedId,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
  Map<String, dynamic> toJson() => _$ChatToJson(this);

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        messages,
        createdAt,
        updatedAt,
        selectedId,
      ];

  Chat copyWith({
    String? id,
    String? userId,
    String? title,
    List<Message>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? selectedId,
  }) {
    return Chat(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      selectedId: selectedId ?? this.selectedId,
    );
  }
}

@JsonSerializable()
class Message extends Equatable {
  final String id;
  final String content;
  final String role; // 'user' or 'assistant'
  final DateTime timestamp;
  final List<Response>? responses;

  const Message({
    required this.id,
    required this.content,
    required this.role,
    required this.timestamp,
    this.responses,
  });

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);

  @override
  List<Object?> get props => [id, content, role, timestamp, responses];

  Message copyWith({
    String? id,
    String? content,
    String? role,
    DateTime? timestamp,
    List<Response>? responses,
  }) {
    return Message(
      id: id ?? this.id,
      content: content ?? this.content,
      role: role ?? this.role,
      timestamp: timestamp ?? this.timestamp,
      responses: responses ?? this.responses,
    );
  }
}

@JsonSerializable()
class Response extends Equatable {
  final String id;
  @JsonKey(name: 'model_id')
  final String modelId;
  final String content;
  final String provider;

  const Response({
    required this.id,
    required this.modelId,
    required this.content,
    required this.provider,
  });

  factory Response.fromJson(Map<String, dynamic> json) =>
      _$ResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseToJson(this);

  @override
  List<Object?> get props => [id, modelId, content, provider];

  Response copyWith({
    String? id,
    String? modelId,
    String? content,
    String? provider,
  }) {
    return Response(
      id: id ?? this.id,
      modelId: modelId ?? this.modelId,
      content: content ?? this.content,
      provider: provider ?? this.provider,
    );
  }
}