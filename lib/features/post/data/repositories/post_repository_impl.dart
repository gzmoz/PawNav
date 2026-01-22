import 'package:pawnav/features/post/domain/entities/post.dart';
import 'package:pawnav/features/post/domain/entities/post_filter.dart';
import 'package:pawnav/features/post/domain/repositories/post_repository.dart';
import 'package:pawnav/features/post/data/datasources/post_remote_datasource.dart';
import 'package:pawnav/features/post/data/models/post_model.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remote;

  PostRepositoryImpl(this.remote);

  @override
  Future<List<Post>> getPosts({
    PostFilter filter = PostFilter.empty,
  }) async {
    final data = await remote.getPosts(filter: filter);

    return data
        .map((map) => PostModel.fromMap(map))
        .toList();
  }
}




/*class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remote;

  PostRepositoryImpl(this.remote);

  @override
  Future<List<Post>> getPosts() async {
    final rawList = await remote.getPosts();

    return rawList
        .map<Post>((map) => PostModel.fromMap(map) as Post)
        .toList();

  }

}*/
