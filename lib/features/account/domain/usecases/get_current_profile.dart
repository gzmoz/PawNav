import 'package:pawnav/features/account/domain/entities/user_profile_entity.dart';
import 'package:pawnav/features/account/domain/repositories/profile_repository.dart';

class GetCurrentProfile{
  final ProfileRepository repo;

  GetCurrentProfile({required this.repo});

  Future<UserProfileEntity?> call() async {
    return await repo.getCurrentProfile();
  }

}