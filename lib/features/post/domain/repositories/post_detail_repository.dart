import 'package:pawnav/features/post/domain/entities/post.dart';

abstract class PostDetailRepository {
  Future<Post?> getPostById(String postId);

  Future<void> deletePost(String postId);

  Future<void> addPostView(String postId);

  Future<void> toggleSavePost(String postId);

  Future<bool> isPostSaved(String postId);
}
