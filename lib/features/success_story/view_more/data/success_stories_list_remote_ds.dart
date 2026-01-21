import 'package:supabase_flutter/supabase_flutter.dart';

class SuccessStoriesListRemoteDS {
  final SupabaseClient client;
  SuccessStoriesListRemoteDS(this.client);

  Future<List<Map<String, dynamic>>> fetch({
    required int from,
    required int to,
  }) async {
    final res = await client
        .from('success_stories')
        .select('''
          id,
          story,
          created_at,
          post:posts!inner(
            name,
            gender,
            post_type,
            images
          )
        ''')
        .order('created_at', ascending: false)
        .range(from, to);

    return (res as List).cast<Map<String, dynamic>>();
  }
}
