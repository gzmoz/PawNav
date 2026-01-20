import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnav/features/home/success_stories/presentation/cubit/home_success_stories_state.dart';
import 'package:pawnav/features/home/success_stories/data/home_success_story_remote_ds.dart';
import 'package:pawnav/features/home/success_stories/data/home_success_story_model.dart';


class HomeSuccessStoriesCubit
    extends Cubit<HomeSuccessStoriesState> {
  final HomeSuccessStoryRemoteDS remote;

  HomeSuccessStoriesCubit(this.remote)
      : super(HomeSuccessStoriesLoading());

  Future<void> load() async {
    try {
      final List<dynamic> raw = await remote.fetch();

      final List<HomeSuccessStoryModel> stories = raw
          .map((e) =>
          HomeSuccessStoryModel.fromMap(
            e as Map<String, dynamic>,
          ))
          .toList();

      emit(HomeSuccessStoriesLoaded(stories));
    } catch (e) {
      emit(HomeSuccessStoriesError(e.toString()));
    }
  }


}
