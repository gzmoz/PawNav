import 'package:pawnav/features/post/domain/entities/post.dart';

abstract class PostDetailState {}

class PostDetailInitial extends PostDetailState {}

class PostDetailLoading extends PostDetailState {}

class PostDetailLoaded extends PostDetailState {
  final Post post;
  PostDetailLoaded(this.post);
}

class PostDetailError extends PostDetailState {
  final String message;
  PostDetailError(this.message);
}

class PostDeleting extends PostDetailState {}

class PostDeleted extends PostDetailState {}

