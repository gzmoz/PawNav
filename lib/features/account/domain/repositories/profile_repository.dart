import 'package:pawnav/features/account/domain/entities/user_profile_entity.dart';

abstract class ProfileRepository{
  Future<UserProfileEntity?> getCurrentProfile();
}