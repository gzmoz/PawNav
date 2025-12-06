import 'package:pawnav/features/account/data/datasources/profile_remote_datasource.dart';
import 'package:pawnav/features/account/domain/entities/user_profile_entity.dart';
import 'package:pawnav/features/account/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository{
  final ProfileRemoteDataSource remote;

  ProfileRepositoryImpl({required this.remote});

  @override
  Future<UserProfileEntity?> getCurrentProfile() {
    return remote.getCurrentUserProfile();
  }

}