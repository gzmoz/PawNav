import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnav/features/post/domain/usecases/add_post_view.dart';
import 'package:pawnav/features/post/domain/usecases/delete_post.dart';
import 'package:pawnav/features/post/domain/usecases/get_post_by_id.dart';
import 'package:pawnav/features/post/domain/usecases/is_post_saved.dart';
import 'package:pawnav/features/post/domain/usecases/toggle_save_post.dart';
import 'package:pawnav/features/post/presentations/cubit/post_detail_state.dart';

class PostDetailCubit extends Cubit<PostDetailState> {
  final GetPostById getPostById;
  final DeletePost deletePost;
  final AddPostView addPostView;
  final ToggleSavePost toggleSavePost;
  final IsPostSaved isPostSaved;


  PostDetailCubit(
      this.getPostById,
      this.deletePost,
      this.addPostView,
      this.toggleSavePost,
      this.isPostSaved,
      ) : super(PostDetailInitial());

  Future<void> loadPost(String postId) async {
    try {
      emit(PostDetailLoading());

      final post = await getPostById(postId);
      if (post == null) {
        emit(PostDeleted());
        return;
      }

      final saved = await isPostSaved(postId);

      emit(PostDetailLoaded(
        post: post,
        isSaved: saved,
      ));

      addPostView(postId);
    } catch (e) {
      emit(PostDetailError(e.toString()));
    }
  }



  /*Future<void> loadPost(String postId) async {
    try {
      emit(PostDetailLoading());

      final post = await getPostById(postId);

      if (post == null) {
        emit(PostDeleted());
        return;
      }

      emit(PostDetailLoaded(post));

      addPostView(postId);

    } catch (e) {
      emit(PostDetailError(e.toString()));
    }
  }*/



  Future<void> delete(String postId) async {
    try {
      emit(PostDeleting());
      await deletePost(postId);
      emit(PostDeleted());
    } catch (e) {
      emit(PostDetailError(e.toString()));
    }
  }

  Future<void> toggleSave(String postId) async {
    if (state is! PostDetailLoaded) return;

    final current = state as PostDetailLoaded;
    final bool newSavedState = !current.isSaved;

    //  UI hemen değişsin + sinyal ver
    emit(
      current.copyWith(
        isSaved: newSavedState,
        justSaved: newSavedState, // true = saved, false = removed
      ),
    );

    try {
      await toggleSavePost(postId);

      //  Snackbar bir kere gösterilsin diye sinyali temizle
      emit(
        (state as PostDetailLoaded).copyWith(justSaved: null),
      );
    } catch (e) {
      // rollback
      emit(current);
    }
  }


/*Future<void> toggleSave(String postId) async {
    if (state is! PostDetailLoaded) return;

    final current = state as PostDetailLoaded;

    //  UI’ı HEMEN değiştir
    emit(current.copyWith(isSaved: !current.isSaved));

    try {
      //  DB’de save / unsave
      await toggleSavePost(postId);
    } catch (e) {
      //  hata olursa eski state’e geri dön
      emit(current);
    }
  }*/


}