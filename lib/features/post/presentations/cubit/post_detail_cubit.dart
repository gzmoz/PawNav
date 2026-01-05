import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnav/features/post/domain/usecases/delete_post.dart';
import 'package:pawnav/features/post/domain/usecases/get_post_by_id.dart';
import 'package:pawnav/features/post/presentations/cubit/post_detail_state.dart';

class PostDetailCubit extends Cubit<PostDetailState> {
  final GetPostById getPostById;
  final DeletePost deletePost;


  PostDetailCubit(this.getPostById, this.deletePost) : super(PostDetailInitial());

  /*Future<void> loadPost(String postId) async {
    try {
      emit(PostDetailLoading());
      final post = await getPostById(postId);
      emit(PostDetailLoaded(post));
    } catch (e) {
      emit(PostDetailError(e.toString()));
    }
  }*/
  Future<void> loadPost(String postId) async {
    try {
      emit(PostDetailLoading());

      final post = await getPostById(postId);

      if (post == null) {
        emit(PostDeleted());
        return;
      }

      emit(PostDetailLoaded(post));
    } catch (e) {
      emit(PostDetailError(e.toString()));
    }
  }



  Future<void> delete(String postId) async {
    try {
      emit(PostDeleting());
      await deletePost(postId);
      emit(PostDeleted());
    } catch (e) {
      emit(PostDetailError(e.toString()));
    }
  }
}