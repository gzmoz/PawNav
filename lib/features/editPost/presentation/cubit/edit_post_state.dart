import 'package:pawnav/features/editPost/domain/entities/edit_post_entity.dart';

abstract class EditPostState {}

class EditPostInitial extends EditPostState {}
class EditPostLoading extends EditPostState {}

class EditPostLoaded extends EditPostState {
  final EditPost post;
  EditPostLoaded(this.post);
}

class EditPostSaving extends EditPostState {}
class EditPostSuccess extends EditPostState {}

class EditPostError extends EditPostState {
  final String message;
  EditPostError(this.message);
}
