import '../entities/edit_post_entity.dart';
import '../repositories/edit_post_repository.dart';

class GetPostForEdit {
  final EditPostRepository repository;

  GetPostForEdit(this.repository);

  Future<EditPost> call(String postId) {
    return repository.getPostById(postId);
  }
}
