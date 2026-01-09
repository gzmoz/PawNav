import 'package:pawnav/features/account/data/repositories/post_repository.dart';
import 'package:pawnav/features/post/domain/repositories/post_detail_repository.dart';

class ToggleSavePost {
  final PostDetailRepository repository;

  ToggleSavePost(this.repository);

  Future<void> call(String postId) {
    return repository.toggleSavePost(postId);
  }
}
