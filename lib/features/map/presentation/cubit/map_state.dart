import 'package:pawnav/features/map/domain/entities/map_post.dart';

sealed class MapState {}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapLoaded extends MapState {
  final List<MapPost> posts;
  final MapPost? selectedPost;

  MapLoaded({
    required this.posts,
    this.selectedPost,
  });

  MapLoaded copyWith({
    List<MapPost>? posts,
    MapPost? selectedPost,
  }) {
    return MapLoaded(
      posts: posts ?? this.posts,
      selectedPost: selectedPost,
    );
  }
}

class MapError extends MapState {
  final String message;

  MapError(this.message);
}
