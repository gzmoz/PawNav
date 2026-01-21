import '../entities/post.dart';
import '../repositories/post_repository.dart';

class GetPosts {
  final PostRepository repo;
  GetPosts(this.repo);

  Future<List<Post>> call() {
    return repo.getPosts();
  }
}
