import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/llm_provider.dart';

part 'llm_provider_model.g.dart';

@JsonSerializable()
class LlmProviderModel extends LlmProvider {
  LlmProviderModel({
    required String id,
    required String name,
    required String description,
    required List<String> models,
    required bool requiresKey,
    String? endpoint,
  }) : super(
          id: id,
          name: name,
          description: description,
          models: models,
          requiresKey: requiresKey,
          endpoint: endpoint,
        );

  factory LlmProviderModel.fromJson(Map<String, dynamic> json) =>
      _$LlmProviderModelFromJson(json);

  Map<String, dynamic> toJson() => _$LlmProviderModelToJson(this);
}