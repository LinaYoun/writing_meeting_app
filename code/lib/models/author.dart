class Author {
  final String id;
  final String name;
  final String avatarUrl;
  final bool isVerified;

  const Author({
    required this.id,
    required this.name,
    required this.avatarUrl,
    this.isVerified = false,
  });
}
