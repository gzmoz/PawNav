import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class PostRemoteDataSource {
  final SupabaseClient client;

  PostRemoteDataSource(this.client);

  Future<List<Map<String, dynamic>>> getPosts() async {
    final res = await client
        .from('posts')
        .select('''
          id,
          user_id,
          species,
          breed,
          color,
          gender,
          name,
          description,
          location,
          event_date,
          images,
          post_type,
          views,
          profiles (
            id,
            name,
            username,
            photo_url
          )
        ''')
        .order('created_at', ascending: false);

    return (res as List).cast<Map<String, dynamic>>();
  }
}

