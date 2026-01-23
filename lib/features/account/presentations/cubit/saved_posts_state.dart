import 'package:pawnav/features/account/data/models/post_model.dart';

abstract class SavedPostsState {}

class SavedPostsLoading extends SavedPostsState {}

class SavedPostsError extends SavedPostsState {
  final String message;
  SavedPostsError(this.message);
}
class SavedPostsLoaded extends SavedPostsState {
  final List<PostModel> posts;
  SavedPostsLoaded(this.posts);
}


