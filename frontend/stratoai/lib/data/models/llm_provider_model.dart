import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';


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
