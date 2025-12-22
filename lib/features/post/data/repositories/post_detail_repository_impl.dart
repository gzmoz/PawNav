import 'package:pawnav/features/post/data/datasources/post_detail_remote_datasource.dart';
import 'package:pawnav/features/post/domain/entities/post.dart';
import 'package:pawnav/features/post/domain/repositories/post_detail_repository.dart';

class PostDetailRepositoryImpl  implements PostDetailRepository {
  final PostDetailRemoteDataSource remote;

  PostDetailRepositoryImpl(this.remote);

  @override
  Future<Post> getPostById(String postId) {
    return remote.getPostById(postId);
  }

  @override
  Future<void> deletePost(String postId) {
    return remote.deletePost(postId);
  }
}