import '../entities/edit_post_entity.dart';
import '../repositories/edit_post_repository.dart';

class UpdatePost {
  final EditPostRepository repository;

  UpdatePost(this.repository);

  Future<void> call(EditPost post) {
    return repository.updatePost(post);
  }
}
