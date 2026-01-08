import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnav/features/home/domain/usecases/get_posts_by_views.dart';
import 'featured_posts_state.dart';

class FeaturedPostsCubit extends Cubit<FeaturedPostsState> {
  final GetPostsByViews getPostsByViews;

  FeaturedPostsCubit(this.getPostsByViews) : super(FeaturedPostsInitial());

  Future<void> loadTop({required int limit}) async {
    emit(FeaturedPostsLoading());

    try {
      final posts = await getPostsByViews(limit: limit);
      emit(FeaturedPostsLoaded(posts));
    } catch (e) {
      emit(FeaturedPostsError(e.toString()));
    }
  }

  /*Future<void> loadTop5() async {
    try {
      emit(FeaturedPostsLoading());
      final posts = await getPostsByViews(limit: 5);
      emit(FeaturedPostsLoaded(posts));
    } catch (e) {
      emit(FeaturedPostsError(e.toString()));
    }
  }*/
}
