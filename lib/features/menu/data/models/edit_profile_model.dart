import '../../domain/entities/edit_profile_entity.dart';

class EditProfileModel extends EditProfileEntity {
  EditProfileModel({
    required super.id,
    required super.name,
    required super.username,
    required super.email,
    required super.createdAt,
    super.photoUrl,
  });

  factory EditProfileModel.fromJson(Map<String, dynamic> json) {
    return EditProfileModel(
      id: json['id'],
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      photoUrl: json['photo_url'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
