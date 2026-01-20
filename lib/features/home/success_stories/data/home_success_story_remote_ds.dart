import 'package:supabase_flutter/supabase_flutter.dart';

class HomeSuccessStoryRemoteDS {
  final SupabaseClient client;
  HomeSuccessStoryRemoteDS(this.client);

  Future<List<dynamic>> fetch() async {
    final res = await client
        .from('success_stories')
        .select('''
        id,
        story,
        created_at,
        post:posts (
          name,
          gender,
          post_type,
          images
        )
      ''')
        .order('created_at', ascending: false)
        .limit(10);

    return res;
  }

}
