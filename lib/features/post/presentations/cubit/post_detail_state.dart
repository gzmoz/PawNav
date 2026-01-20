import 'package:pawnav/features/post/domain/entities/post.dart';

abstract class PostDetailState {}

class PostDetailInitial extends PostDetailState {}

class PostDetailLoading extends PostDetailState {}

class PostDetailError extends PostDetailState {
  final String message;

  PostDetailError(this.message);
}



class PostDeleting extends PostDetailState {}

class PostDeleted extends PostDetailState {}

class PostDetailLoaded extends PostDetailState {
  final Post post;
  final bool isSaved;
  final bool hasSuccessStory;
  final bool? justSaved;
  final String? successStoryId;
  final bool isOwner;

  PostDetailLoaded({
    required this.post,
    required this.isSaved,
    required this.hasSuccessStory,
    required this.isOwner,
    this.successStoryId,
    this.justSaved,
  });

  PostDetailLoaded copyWith({
    bool? isSaved,
    bool? hasSuccessStory,
    bool? justSaved,
    bool? isOwner,
  }) {
    return PostDetailLoaded(
      post: post,
      isSaved: isSaved ?? this.isSaved,
      hasSuccessStory: hasSuccessStory ?? this.hasSuccessStory,
      justSaved: justSaved,
      successStoryId: successStoryId ?? this.successStoryId,
      isOwner: isOwner ?? this.isOwner,
    );
  }
}


/*class PostDetailLoaded extends PostDetailState {
  final Post post;
  final bool isSaved;
  final bool hasSuccessStory;
  final bool? justSaved;
  final bool isOwner;

  PostDetailLoaded({
    required this.post,
    required this.isSaved,
    required this.hasSuccessStory,
    required this.isOwner,
    this.justSaved,
  });

  PostDetailLoaded copyWith({
    bool? isSaved,
    bool? hasSuccessStory,
    bool? justSaved,
    bool? isOwner,
  }) {
    return PostDetailLoaded(
      post: post,
      isSaved: isSaved ?? this.isSaved,
      hasSuccessStory: hasSuccessStory ?? this.hasSuccessStory,
      justSaved: justSaved,
      isOwner: isOwner ?? this.isOwner,
    );
  }
}*/

class PostUnsaved extends PostDetailState {}



