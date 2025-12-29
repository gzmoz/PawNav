import 'package:pawnav/features/editPost/data/datasources/edit_post_remote_datasource.dart';
import 'package:pawnav/features/editPost/data/models/edit_post_model.dart';
import 'package:pawnav/features/editPost/domain/entities/edit_post_entity.dart';
import 'package:pawnav/features/editPost/domain/repositories/edit_post_repository.dart';

class EditPostRepositoryImpl implements EditPostRepository {
  final EditPostRemoteDataSource remote;

  EditPostRepositoryImpl(this.remote);

  @override
  Future<EditPost> getPostById(String postId) async {
    final model = await remote.getPostById(postId);
    return model;
  }

  @override
  Future<void> updatePost(EditPost post) async {
    final model = EditPostModel.fromEntity(post);
    await remote.updatePost(model);
  }
}

