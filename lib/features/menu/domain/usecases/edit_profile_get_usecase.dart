import 'package:pawnav/features/menu/domain/entities/edit_profile_entity.dart';
import 'package:pawnav/features/menu/domain/repositories/edit_profile_repository.dart';

class EditProfileGetUseCase {
  final EditProfileRepository repository;

  EditProfileGetUseCase(this.repository);

  Future<EditProfileEntity> call() {
    return repository.editProfileGet();
  }
}
