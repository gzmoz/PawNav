class PostOwner {
  final String id;
  final String name;
  final String username;
  final String? photoUrl;

  PostOwner({
    required this.id,
    required this.name,
    required this.username,
    this.photoUrl,
  });
}
