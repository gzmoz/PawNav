import 'package:pawnav/features/post/data/models/post_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostDetailRemoteDataSource {
  final SupabaseClient client;

  PostDetailRemoteDataSource(this.client);

  Future<PostModel?> getPostById(String postId) async {
    final response = await client.from('posts').select('''
    *,
    profiles (
      id,
      name,
      username,
      photo_url
    )
  ''').eq('id', postId).maybeSingle();

    if (response == null) {
      return null;
    }

    return PostModel.fromMap(response);
  }

  Future<void> deletePost(String postId) async {
    await client.from('posts').delete().eq('id', postId);
  }

  /*Future<void> addPostView(String postId) async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) return;

    //“Bu kullanıcı bu postu görüntüledi” kaydını ekliyor:
    await client.from('post_views').insert({
      'post_id': postId,
      'user_id': userId,
    });
  }*/

  Future<void> toggleSavePost(String postId) async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) return;

    final existing = await client
        .from('saved_posts')
        .select('id')
        .eq('user_id', userId)
        .eq('post_id', postId)
        .maybeSingle();

    if (existing != null) {
      // UNSAVE
      await client
          .from('saved_posts')
          .delete()
          .eq('user_id', userId)
          .eq('post_id', postId);
    } else {
      // SAVE
      await client.from('saved_posts').insert({
        'user_id': userId,
        'post_id': postId,
      });
    }
  }

  Future<bool> isPostSaved(String postId) async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) return false;

    final res = await client
        .from('saved_posts')
        .select('id')
        .eq('user_id', userId)
        .eq('post_id', postId)
        .maybeSingle();

    return res != null;
  }

  Future<void> addPostView(String postId, String userId) async {
    await client.from('post_views').upsert(
      {
        'post_id': postId,
        'user_id': userId,
      },
      onConflict: 'post_id,user_id',
    );
  }

}
