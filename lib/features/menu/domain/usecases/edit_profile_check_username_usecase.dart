import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileCheckUsernameUseCase {
  final SupabaseClient client;

  EditProfileCheckUsernameUseCase(this.client);

  Future<bool> isUsernameAvailable({
    required String username,
    required String currentUserId,
  }) async {
    final res = await client
        .from('profiles')
        .select('id')
        .eq('username', username)
        .neq('id', currentUserId)
        .maybeSingle();

    return res == null;
  }
}
