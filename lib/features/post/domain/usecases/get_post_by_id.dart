import 'package:pawnav/features/post/domain/entities/post.dart';
import 'package:pawnav/features/post/domain/repositories/post_detail_repository.dart';

class GetPostById {
  final PostDetailRepository repository;

  GetPostById(this.repository);

  Future<Post> call(String postId) {
    return repository.getPostById(postId);
  }
}