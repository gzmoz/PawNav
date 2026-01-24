import '../entities/edit_profile_entity.dart';

abstract class EditProfileRepository {
  Future<EditProfileEntity> editProfileGet();
  Future<void> editProfileSave({
    required String name,
    required String username,
    String? photoUrl,
  });
}

