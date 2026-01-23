import 'package:pawnav/features/post/domain/entities/post.dart';
import 'package:pawnav/features/post/domain/entities/post_filter.dart';

abstract class PostRepository {
  Future<List<Post>> getPosts({
    PostFilter filter = PostFilter.empty,
  });
}
