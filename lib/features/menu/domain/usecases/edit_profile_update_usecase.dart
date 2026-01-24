import 'package:pawnav/features/menu/domain/repositories/edit_profile_repository.dart';

class EditProfileUpdateUseCase {
  final EditProfileRepository repository;

  EditProfileUpdateUseCase(this.repository);

  Future<void> call({
    required String name,
    required String username,
    String? photoUrl,
  }) {
    return repository.editProfileSave(
      name: name,
      username: username,
      photoUrl: photoUrl,
    );
  }
}
