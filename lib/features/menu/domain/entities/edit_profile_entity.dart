class EditProfileEntity {
  final String id;
  final String name;
  final String username;
  final String email;
  final String? photoUrl;
  final DateTime createdAt;

  const EditProfileEntity({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.photoUrl,
    required this.createdAt,
  });

  EditProfileEntity copyWith({
    String? id,
    String? name,
    String? username,
    String? email,
    String? photoUrl,
    DateTime? createdAt,
  }) {
    return EditProfileEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
