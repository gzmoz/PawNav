import 'package:pawnav/features/success_story/data/models/account_success_story_item.dart';

abstract class AccountSuccessStoriesState {}

class AccountSuccessStoriesInitial extends AccountSuccessStoriesState {}

class AccountSuccessStoriesLoading extends AccountSuccessStoriesState {}

class AccountSuccessStoriesLoaded extends AccountSuccessStoriesState {
  final List<AccountSuccessStoryItem> stories;

  AccountSuccessStoriesLoaded(this.stories);
}

class AccountSuccessStoriesError extends AccountSuccessStoriesState {
  final String message;

  AccountSuccessStoriesError(this.message);
}
