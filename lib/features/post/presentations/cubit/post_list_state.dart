import '../../domain/entities/post.dart';

sealed class PostListState {}

class PostListLoading extends PostListState {}

class PostListLoaded extends PostListState {
  final List<Post> posts;
  PostListLoaded(this.posts);
}

class PostListError extends PostListState {
  final String message;
  PostListError(this.message);
}
