import 'package:pawnav/features/post/domain/entities/post.dart';

abstract class FeaturedPostsState {}

class FeaturedPostsInitial extends FeaturedPostsState {}
class FeaturedPostsLoading extends FeaturedPostsState {}

class FeaturedPostsLoaded extends FeaturedPostsState {
  final List<Post> posts;
  FeaturedPostsLoaded(this.posts);
}

class FeaturedPostsError extends FeaturedPostsState {
  final String message;
  FeaturedPostsError(this.message);
}
