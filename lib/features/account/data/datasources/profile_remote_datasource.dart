import 'package:pawnav/features/account/domain/entities/user_profile_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRemoteDataSource {
  final SupabaseClient client;

  ProfileRemoteDataSource({required this.client});

  Future<UserProfileEntity?> getCurrentUserProfile() async {
    final uid = client.auth.currentUser!.id;

    final data = await client
        .from("profiles")
        .select("*")
        .eq("id", uid)
        .maybeSingle();

    if(data == null) return null;

    return UserProfileEntity(
        id: data['id'],
        name: data['name'] ?? '',
        username: data['username'] ?? '',
        email: data['email'] ?? '',
        photoUrl: data['photo_url'] ?? '',
    );
  }


}