import 'package:pawnav/features/post/domain/entities/post.dart';

abstract class PostDetailState {}

class PostDetailInitial extends PostDetailState {}

class PostDetailLoading extends PostDetailState {}

/*class PostDetailLoaded extends PostDetailState {
  final Post post;
  PostDetailLoaded(this.post);
}*/

class PostDetailError extends PostDetailState {
  final String message;
  PostDetailError(this.message);
}

class PostDeleting extends PostDetailState {}

class PostDeleted extends PostDetailState {}

// class PostDetailLoaded extends PostDetailState {
//   final Post post;
//   final bool isSaved;
//
//   final bool? justSaved; // true = saved, false = removed, null = no message
//
//   PostDetailLoaded({
//     required this.post,
//     this.isSaved = false,
//     this.justSaved,
//   });
//
//   PostDetailLoaded copyWith({
//     Post? post,
//     bool? isSaved,
//     bool? justSaved,
//   }) {
//     return PostDetailLoaded(
//       post: post ?? this.post,
//       isSaved: isSaved ?? this.isSaved,
//       justSaved: justSaved,
//     );
//   }
// }

class PostDetailLoaded extends PostDetailState {
  final Post post;
  final bool isSaved;
  final bool hasSuccessStory;
  final bool? justSaved;

  PostDetailLoaded({
    required this.post,
    required this.isSaved,
    required this.hasSuccessStory,
    this.justSaved,
  });

  PostDetailLoaded copyWith({
    bool? isSaved,
    bool? hasSuccessStory,
    bool? justSaved,
  }) {
    return PostDetailLoaded(
      post: post,
      isSaved: isSaved ?? this.isSaved,
      hasSuccessStory: hasSuccessStory ?? this.hasSuccessStory,
      justSaved: justSaved,
    );
  }
}




