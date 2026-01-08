import 'package:pawnav/features/post/domain/entities/post.dart';

abstract class HomeRepository {
  Future<List<Post>> getPostsByViews({
    required int limit,
    int? lastViews,
    String? lastId,
  });
}
