import 'package:pawnav/features/addPost/domain/entities/add_post_entity.dart';
import 'package:pawnav/features/addPost/domain/repositories/add_post_repository.dart';

//“Usecase” = gerçek hayattaki bir iş / işlem:
class AddPost{
  final PostRepository repository;

  AddPost({required this.repository});

  Future<void> call(Post post){
    return repository.addPost(post);
  }


}