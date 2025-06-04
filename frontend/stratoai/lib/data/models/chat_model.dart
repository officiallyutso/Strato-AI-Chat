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
