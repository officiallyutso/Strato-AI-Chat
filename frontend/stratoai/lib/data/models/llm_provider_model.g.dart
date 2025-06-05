// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'llm_provider_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LLMModel _$LLMModelFromJson(Map<String, dynamic> json) => LLMModel(
  id: json['id'] as String,
  name: json['name'] as String,
  provider: json['provider'] as String,
  description: json['description'] as String,
  iconPath: json['icon_path'] as String,
  isAvailable: json['is_available'] as bool? ?? true,
);

Map<String, dynamic> _$LLMModelToJson(LLMModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'provider': instance.provider,
  'description': instance.description,
  'icon_path': instance.iconPath,
  'is_available': instance.isAvailable,
};

APIKey _$APIKeyFromJson(Map<String, dynamic> json) => APIKey(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  provider: json['provider'] as String,
  key: json['key'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$APIKeyToJson(APIKey instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'provider': instance.provider,
  'key': instance.key,
  'created_at': instance.createdAt.toIso8601String(),
};
