class ApiKey {
  final String id;
  final String userId;
  final String provider;
  final String key;
  final DateTime createdAt;

  ApiKey({
    required this.id,
    required this.userId,
    required this.provider,
    required this.key,
    required this.createdAt,
  });
}