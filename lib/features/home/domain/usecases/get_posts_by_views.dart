import 'package:pawnav/features/home/domain/repositories/home_repository.dart';
import 'package:pawnav/features/post/domain/entities/post.dart';

class GetPostsByViews {
  final HomeRepository repository;

  GetPostsByViews(this.repository);

  Future<List<Post>> call({required int limit}) {
    return repository.getPostsByViews(limit: limit);
  }
}

/*
class GetPostsByViews {
  final HomeRepository repository;

  GetPostsByViews(this.repository);

  Future<List<Post>> call({
    required int limit,
    int? lastViews,
    String? lastId,
  }) {
    return repository.getPostsByViews(
      limit: limit,
      lastViews: lastViews,
      lastId: lastId,
    );
  }
}
*/
