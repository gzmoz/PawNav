import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileRemoteDataSource {
  final SupabaseClient client;

  EditProfileRemoteDataSource(this.client);

  Future<Map<String, dynamic>> editProfileFetch() async {
    final userId = client.auth.currentUser!.id;

    return await client
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();
  }

  Future<void> editProfileUpdate({
    required String name,
    required String username,
    String? photoUrl,
  }) async {
    final userId = client.auth.currentUser!.id;

    await client.from('profiles').update({
      'name': name,
      'username': username,
      'photo_url': photoUrl,
    }).eq('id', userId);
  }
}
