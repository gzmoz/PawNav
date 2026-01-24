import '../../domain/entities/edit_profile_entity.dart';
import '../../domain/repositories/edit_profile_repository.dart';
import '../datasources/edit_profile_remote_datasource.dart';
import '../models/edit_profile_model.dart';

class EditProfileRepositoryImpl implements EditProfileRepository {
  final EditProfileRemoteDataSource remote;

  EditProfileRepositoryImpl(this.remote);

  @override
  Future<EditProfileEntity> editProfileGet() async {
    final data = await remote.editProfileFetch();
    return EditProfileModel.fromJson(data);
  }

  @override
  Future<void> editProfileSave({
    required String name,
    required String username,
    String? photoUrl,
  }) async {
    await remote.editProfileUpdate(
      name: name,
      username: username,
      photoUrl: photoUrl,
    );
  }
}
