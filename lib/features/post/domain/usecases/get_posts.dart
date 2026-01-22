import 'package:pawnav/features/post/domain/entities/post.dart';
import 'package:pawnav/features/post/domain/entities/post_filter.dart';
import 'package:pawnav/features/post/domain/repositories/post_repository.dart';

class GetPosts {
  final PostRepository repo;

  GetPosts(this.repo);

  Future<List<Post>> call({
    PostFilter filter = PostFilter.empty,
  }) {
    return repo.getPosts(filter: filter);
  }
}




/*class GetPosts {
  final PostRepository repo;
  GetPosts(this.repo);

  Future<List<Post>> call() {
    return repo.getPosts();
  }
}*/
