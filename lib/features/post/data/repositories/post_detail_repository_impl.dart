import 'package:pawnav/features/post/data/datasources/post_detail_remote_datasource.dart';
import 'package:pawnav/features/post/domain/entities/post.dart';
import 'package:pawnav/features/post/domain/repositories/post_detail_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostDetailRepositoryImpl  implements PostDetailRepository {
  final PostDetailRemoteDataSource remote;
  final SupabaseClient supabase;



  PostDetailRepositoryImpl(this.remote, this.supabase);


  @override
  Future<Post?> getPostById(String postId) async {
    final model = await remote.getPostById(postId);
    return model;
  }

  @override
  Future<void> deletePost(String postId) {
    return remote.deletePost(postId);
  }

  /*@override
  Future<void> addPostView(String postId) {
    return remote.addPostView(postId);
  }*/

  @override
  Future<void> addPostView(String postId) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    return remote.addPostView(postId, userId);
  }

  @override
  Future<void> toggleSavePost(String postId) {
    return remote.toggleSavePost(postId);
  }

  Future<bool> isPostSaved(String postId) {
    return remote.isPostSaved(postId);
  }


}