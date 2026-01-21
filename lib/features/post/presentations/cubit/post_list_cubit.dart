import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_posts.dart';
import 'post_list_state.dart';

class PostListCubit extends Cubit<PostListState> {
  final GetPosts getPosts;

  PostListCubit(this.getPosts) : super(PostListLoading());

  /*Future<void> load() async {
    try {
      emit(PostListLoading());
      final posts = await getPosts();
      emit(PostListLoaded(posts));
    } catch (e) {
      emit(PostListError(e.toString()));
    }
  }*/

  Future<void> load({bool newestFirst = true}) async {
    emit(PostListLoading());

    try {
      final posts = await getPosts();

      final sorted = [...posts]
        ..sort(
              (a, b) => newestFirst
              ? b.eventDate.compareTo(a.eventDate) // Newest → Oldest
              : a.eventDate.compareTo(b.eventDate), // Oldest → Newest
        );

      emit(PostListLoaded(sorted));
    } catch (e) {
      emit(PostListError(e.toString()));
    }
  }

}

