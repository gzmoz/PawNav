import '../../domain/success_story_filter.dart';
import '../../data/success_story_list_item_model.dart';

sealed class SuccessStoriesListState {}

class SuccessStoriesListLoading extends SuccessStoriesListState {}

class SuccessStoriesListLoaded extends SuccessStoriesListState {
  final List<SuccessStoryListItemModel> stories;

  final SuccessStoryFilter filter;
  final String searchQuery;

  final bool isLoadingMore;
  final bool hasMore;

  SuccessStoriesListLoaded({
    required this.stories,
    required this.filter,
    required this.searchQuery,
    required this.isLoadingMore,
    required this.hasMore,
  });

  SuccessStoriesListLoaded copyWith({
    List<SuccessStoryListItemModel>? stories,
    SuccessStoryFilter? filter,
    String? searchQuery,
    bool? isLoadingMore,
    bool? hasMore,
  }) {
    return SuccessStoriesListLoaded(
      stories: stories ?? this.stories,
      filter: filter ?? this.filter,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class SuccessStoriesListError extends SuccessStoriesListState {
  final String message;

  SuccessStoriesListError(this.message);
}
