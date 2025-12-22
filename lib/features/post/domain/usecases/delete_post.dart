import 'package:pawnav/features/post/domain/repositories/post_detail_repository.dart';

class DeletePost {
  final PostDetailRepository repository;

  DeletePost(this.repository);

  Future<void> call(String postId) {
    return repository.deletePost(postId);
  }
}
