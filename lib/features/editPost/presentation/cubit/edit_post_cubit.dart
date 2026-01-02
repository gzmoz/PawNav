import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawnav/features/editPost/domain/entities/edit_post_entity.dart';
import 'package:pawnav/features/editPost/domain/usecases/get_post_for_edit.dart';
import 'package:pawnav/features/editPost/domain/usecases/update_post.dart';
import 'package:pawnav/features/editPost/presentation/cubit/edit_post_state.dart';

class EditPostCubit extends Cubit<EditPostState> {
  final GetPostForEdit getPostForEdit;
  final UpdatePost updatePost;

  EditPostCubit({
    required this.getPostForEdit,
    required this.updatePost,
  }) : super(EditPostInitial());

  Future<void> load(String postId) async {
    try {
      emit(EditPostLoading());
      final post = await getPostForEdit(postId);
      emit(EditPostLoaded(post));
    } catch (e) {
      emit(EditPostError(e.toString()));
    }
  }

  Future<void> save(
      EditPost post, {
        List<XFile> newImages = const [],
        List<String> removedImages = const [],
      }) async {
    try {
      emit(EditPostSaving());

      await updatePost(
        post,
        newImages: newImages,
        removedImages: removedImages,
      );

      emit(EditPostSuccess());
    } catch (e) {
      emit(EditPostError(e.toString()));
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      emit(EditPostSaving());
      await updatePost.repository.deletePost(postId);
      emit(EditPostSuccess());
    } catch (e) {
      emit(EditPostError(e.toString()));
    }
  }



/*Future<void> save(EditPost post) async {
    try {
      emit(EditPostSaving());
      await updatePost(post);
      emit(EditPostSuccess());
    } catch (e) {
      emit(EditPostError(e.toString()));
    }
  }*/



}
