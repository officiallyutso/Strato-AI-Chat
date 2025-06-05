class Chat {
  final String id;
  final String userId;
  final String title;
  final List<Message> messages;
  final DateTime createdAt;
  final DateTime updatedAt;
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
}

class Message {
  final String id;
  final String content;
  final String role;
  final DateTime timestamp;
  final List<Response>? responses;

  const Message({
    required this.id,
    required this.content,
    required this.role,
    required this.timestamp,
    this.responses,
  });
}

class Response {
  final String id;
  final String modelId;
  final String content;
  final String provider;
  final String? error;

  const Response({
    required this.id,
    required this.modelId,
    required this.content,
    required this.provider,
    this.error,
  });
}