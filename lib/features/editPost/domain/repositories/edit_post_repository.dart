import '../entities/edit_post_entity.dart';

abstract class EditPostRepository {
  Future<EditPost> getPostById(String postId);
  Future<void> updatePost(EditPost post);
}
