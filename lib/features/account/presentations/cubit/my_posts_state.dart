import 'package:pawnav/features/account/data/models/post_model.dart';

abstract class MyPostsState{}

class MyPostsInitial extends MyPostsState{}
class MyPostsLoading extends MyPostsState {}

class MyPostsLoaded extends MyPostsState {
  final List<PostModel> posts;
  MyPostsLoaded(this.posts);
}

class MyPostsError extends MyPostsState {
  final String message;
  MyPostsError(this.message);
}
