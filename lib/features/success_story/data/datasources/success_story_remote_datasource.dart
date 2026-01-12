import 'package:supabase_flutter/supabase_flutter.dart';

class SuccessStoryRemoteDataSource {
  final SupabaseClient client;

  SuccessStoryRemoteDataSource(this.client);

  Future<Map<String, dynamic>> getPostById(String postId) async {
    final res = await client
        .from('posts')
        .select(
            'id, user_id, name, species, breed, created_at, post_type, images')
        .eq('id', postId)
        .single();
    return res;
  }

  Future<Map<String, dynamic>> getProfileById(String userId) async {
    final res = await client
        .from('profiles')
        .select('id, name, username, photo_url')
        .eq('id', userId)
        .single();
    return res;
  }

  Future<List<Map<String, dynamic>>> searchProfiles(String query) async {
    if (query.trim().isEmpty) return []; //Boş string ile DB’ye istek atma
    final q = query.trim(); //Baş–son boşlukları temizle

    final res = await client
        .from('profiles')
        .select('id, name, username, photo_url')
        .or('name.ilike.%$q%,username.ilike.%$q%')
        .limit(20);

    //ilike → case-insensitive , % → contains
    /* WHERE name ILIKE '%q%'
    *OR username ILIKE '%q%'
    * */

    //Supabase dynamic döndürür
    return (res as List).cast<Map<String, dynamic>>();
  }

  Future<void> createSuccessStory({
    required String postId,
    required String ownerId,
    required String story,
    String? heroId,
  }) async {
    await client.from('success_stories').insert({
      'post_id': postId,
      'owner_id': ownerId,
      'hero_id': heroId,
      'story': story,
    });
  }
}
