class LlmProvider {
  final String id;
  final String name;
  final String provider;
  final String description;
  final String iconPath;
  final bool isAvailable;

  const LlmProvider({
    required this.id,
    required this.name,
    required this.provider,
    required this.description,
    required this.iconPath,
    this.isAvailable = true,
  });
}