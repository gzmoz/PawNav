import 'package:pawnav/features/post/domain/repositories/post_detail_repository.dart';

class AddPostView {
  final PostDetailRepository repository;

  AddPostView(this.repository);

  Future<void> call(String postId) {
    return repository.addPostView(postId);
  }
}
