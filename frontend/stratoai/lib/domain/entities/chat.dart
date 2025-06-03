class Chat {
  final String id;
  final String userId;
  final String prompt;
  final List<Response> responses;
  final String? selectedId;
  final DateTime createdAt;
  final List<String> chainedChats;

  Chat({
    required this.id,
    required this.userId,
    required this.prompt,
    required this.responses,
    this.selectedId,
    required this.createdAt,
    required this.chainedChats,
  });
}

class Response {
  final String id;
  final String provider;
  final String model;
  final String content;
  final DateTime createdAt;
  final String? error;

  Response({
    required this.id,
    required this.provider,
    required this.model,
    required this.content,
    required this.createdAt,
    this.error,
  });
}