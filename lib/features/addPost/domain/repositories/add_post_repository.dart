import 'package:pawnav/features/addPost/domain/entities/add_post_entity.dart';

abstract class AddPostRepository{
  Future<void> addPost(Post post);
}