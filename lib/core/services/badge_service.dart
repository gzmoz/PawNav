import 'package:supabase_flutter/supabase_flutter.dart';

class BadgeService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<int> getEarnedBadgeCount() async {
    final userId = _client.auth.currentUser!.id;

    final response = await _client
        .from('user_badges')
        .select('id')
        .eq('user_id', userId);

    return response.length;
  }
}
