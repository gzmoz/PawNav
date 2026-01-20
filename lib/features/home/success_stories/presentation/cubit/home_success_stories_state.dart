import 'package:pawnav/features/home/success_stories/data/home_success_story_model.dart';

sealed class HomeSuccessStoriesState {}

class HomeSuccessStoriesLoading extends HomeSuccessStoriesState {}

class HomeSuccessStoriesLoaded extends HomeSuccessStoriesState {
  final List<HomeSuccessStoryModel> stories;
  HomeSuccessStoriesLoaded(this.stories);
}

class HomeSuccessStoriesError extends HomeSuccessStoriesState {
  final String message;
  HomeSuccessStoriesError(this.message);
}
