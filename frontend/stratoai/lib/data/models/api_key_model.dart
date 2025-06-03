import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/api_key.dart';

part 'api_key_model.g.dart';

@JsonSerializable()
class ApiKeyModel extends ApiKey {
  ApiKeyModel({
    required String id,
    required String userId,
    required String provider,
    required String key,
    required DateTime createdAt,
  }) : super(
          id: id,
          userId: userId,
          provider: provider,
          key: key,
          createdAt: createdAt,
        );

  factory ApiKeyModel.fromJson(Map<String, dynamic> json) =>
      _$ApiKeyModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApiKeyModelToJson(this);
}