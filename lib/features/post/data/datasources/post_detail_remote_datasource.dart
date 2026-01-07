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

  Future<void> addPostView(String postId) async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) return;

    await client.from('post_views').insert({
      'post_id': postId,
      'user_id': userId,
    });
  }

}

/*Supabase’e git, raw data getir*/ /*

class PostDetailRemoteDataSource {
  final SupabaseClient client;

  PostDetailRemoteDataSource (this.client);

  Future<PostModel?> getPostById(String postId) async{
    final response = await client
        .from('posts')
        .select()
        .eq('id',postId)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return PostModel.fromMap(response);

  }

  Future<void> deletePost(String postId) async {
    await client
        .from('posts')
        .delete()
        .eq('id', postId);
  }


}*/
