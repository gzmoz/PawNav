import 'package:pawnav/features/account/data/datasources/account_post_remote_datasource.dart';
import 'package:pawnav/features/account/data/models/post_model.dart';

class PostRepository{
  final AccountPostRemoteDataSource  remote;

  PostRepository(this.remote);

  Future<List<PostModel>> getMyPosts(String userId){
    return remote.getMyPosts(userId);
  }


}