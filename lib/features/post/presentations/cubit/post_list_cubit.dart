import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnav/features/post/domain/entities/post.dart';
import 'package:pawnav/features/post/domain/entities/post_filter.dart';
import 'package:pawnav/features/post/domain/usecases/get_posts.dart';
import 'package:pawnav/features/post/presentations/cubit/post_list_state.dart';


class PostListCubit extends Cubit<PostListState> {
  final GetPosts getPosts;

  List<Post> _allPosts = <Post>[];

  PostListCubit(this.getPosts) : super(PostListLoading());

  Future<void> load({
    bool newestFirst = true,
    PostFilter filter = PostFilter.empty,
  }) async {
    emit(PostListLoading());

    try {
      final posts = await getPosts(filter: filter);

      final activePosts = posts.where((p) => p.isActive).toList();

      final sorted = [...activePosts]
        ..sort(
              (a, b) => newestFirst
              ? b.eventDate.compareTo(a.eventDate)
              : a.eventDate.compareTo(b.eventDate),
        );

      _allPosts = List<Post>.from(sorted);

      emit(PostListLoaded(sorted));
    } catch (e) {
      emit(PostListError(e.toString()));
    }
  }

  void search(String query) {
    if (query.isEmpty) {
      emit(PostListLoaded(List<Post>.from(_allPosts).cast<Post>()));
      return;
    }

    final q = query.toLowerCase();

    final filtered = _allPosts.where((post) {
      return (post.name?.toLowerCase().contains(q) ?? false) ||
          post.location.toLowerCase().contains(q) ||
          post.description.toLowerCase().contains(q);
    }).toList();

    emit(PostListLoaded(filtered));
  }



/*Future<void> load({
    bool newestFirst = true,
    PostFilter filter = PostFilter.empty,
  }) async {
    emit(PostListLoading());

    try {
      final posts = await getPosts(filter: filter);

      final activePosts = posts.where((p) => p.isActive).toList();

      final sorted = [...activePosts]
        ..sort(
              (a, b) => newestFirst
              ? b.eventDate.compareTo(a.eventDate)
              : a.eventDate.compareTo(b.eventDate),
        );

      emit(PostListLoaded(sorted));
    } catch (e) {
      emit(PostListError(e.toString()));
    }
  }*/

}

