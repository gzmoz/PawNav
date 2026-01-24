import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnav/features/post/domain/entities/post_filter.dart';
import 'package:pawnav/features/post/domain/usecases/get_posts.dart';
import 'package:pawnav/features/post/presentations/cubit/post_list_state.dart';

class PostListCubit extends Cubit<PostListState> {
  final GetPosts getPosts;

  PostListCubit(this.getPosts) : super(PostListLoading());

  Future<void> load({
    bool newestFirst = true,
    PostFilter filter = PostFilter.empty,
  }) async {
    emit(PostListLoading());

    try {
      final posts = await getPosts(filter: filter);

      final sorted = [...posts]
        ..sort(
              (a, b) => newestFirst
              ? b.eventDate.compareTo(a.eventDate)
              : a.eventDate.compareTo(b.eventDate),
        );

      emit(PostListLoaded(sorted));
    } catch (e, s) {
      emit(PostListError(e.toString()));
    }
  }
}

