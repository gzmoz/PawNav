import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/post_remote_datasource.dart';
import '../models/post_model.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remote;

  PostRepositoryImpl(this.remote);

  @override
  Future<List<Post>> getPosts() async {
    final rawList = await remote.getPosts();

    return rawList
        .map<Post>((map) => PostModel.fromMap(map) as Post)
        .toList();

  }

}
