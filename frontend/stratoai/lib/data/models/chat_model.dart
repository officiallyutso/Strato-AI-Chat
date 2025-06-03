import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/chat.dart';

part 'chat_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChatModel extends Chat {
  ChatModel({
    required String id,
    required String userId,
    required String prompt,
    required List<ResponseModel> responses,
    String? selectedId,
    required DateTime createdAt,
    List<String>? chainedChats,
  }) : super(
          id: id,
          userId: userId,
          prompt: prompt,
          responses: responses,
          selectedId: selectedId,
          createdAt: createdAt,
          chainedChats: chainedChats ?? [],
        );

  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatModelToJson(this);
}

@JsonSerializable()
class ResponseModel extends Response {
  ResponseModel({
    required String id,
    required String provider,
    required String model,
    required String content,
    required DateTime createdAt,
    String? error,
  }) : super(
          id: id,
          provider: provider,
          model: model,
          content: content,
          createdAt: createdAt,
          error: error,
        );

  factory ResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseModelToJson(this);
}