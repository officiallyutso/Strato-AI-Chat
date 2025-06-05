import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stratoai/domain/entities/llm_provider.dart';

part 'llm_model.g.dart';

@JsonSerializable()
class LLMModel extends Equatable {
  final String id;
  final String name;
  final String provider;
  final String description;
  @JsonKey(name: 'icon_path')
  final String iconPath;
  @JsonKey(name: 'is_available')
  final bool isAvailable;

  const LLMModel({
    required this.id,
    required this.name,
    required this.provider,
    required this.description,
    required this.iconPath,
    this.isAvailable = true,
  });

  factory LLMModel.fromJson(Map<String, dynamic> json) =>
      _$LLMModelFromJson(json);

  Map<String, dynamic> toJson() => _$LLMModelToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        provider,
        description,
        iconPath,
        isAvailable,
      ];

  LLMModel copyWith({
    String? id,
    String? name,
    String? provider,
    String? description,
    String? iconPath,
    bool? isAvailable,
  }) {
    return LLMModel(
      id: id ?? this.id,
      name: name ?? this.name,
      provider: provider ?? this.provider,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}

@JsonSerializable()
class APIKey extends Equatable {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  final String provider;
  final String key;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  const APIKey({
    required this.id,
    required this.userId,
    required this.provider,
    required this.key,
    required this.createdAt,
  });

  factory APIKey.fromJson(Map<String, dynamic> json) =>
      _$APIKeyFromJson(json);

  Map<String, dynamic> toJson() => _$APIKeyToJson(this);

  @override
  List<Object?> get props => [id, userId, provider, key, createdAt];
}
extension LlmProviderModelX on LLMModel {
  LlmProvider toEntity() {
    return LlmProvider(
      id: id,
      name: name,
      provider: provider,
      description: description,
      iconPath: iconPath,
      isAvailable: isAvailable,
    );
  }
}