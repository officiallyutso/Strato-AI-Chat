// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  title: json['title'] as String,
  messages: (json['messages'] as List<dynamic>)
      .map((e) => Message.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  selectedId: json['selected_id'] as String?,
);

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'title': instance.title,
  'messages': instance.messages,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'selected_id': instance.selectedId,
};

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
  id: json['id'] as String,
  content: json['content'] as String,
  role: json['role'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
  responses: (json['responses'] as List<dynamic>?)
      ?.map((e) => Response.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
  'id': instance.id,
  'content': instance.content,
  'role': instance.role,
  'timestamp': instance.timestamp.toIso8601String(),
  'responses': instance.responses,
};

Response _$ResponseFromJson(Map<String, dynamic> json) => Response(
  id: json['id'] as String,
  modelId: json['model_id'] as String,
  content: json['content'] as String,
  provider: json['provider'] as String,
);

Map<String, dynamic> _$ResponseToJson(Response instance) => <String, dynamic>{
  'id': instance.id,
  'model_id': instance.modelId,
  'content': instance.content,
  'provider': instance.provider,
};
