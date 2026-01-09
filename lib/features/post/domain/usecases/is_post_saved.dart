import 'package:pawnav/features/post/domain/repositories/post_detail_repository.dart';

class IsPostSaved {
  final PostDetailRepository repository;

  IsPostSaved(this.repository);

  Future<bool> call(String postId) {
    return repository.isPostSaved(postId);
  }
}
