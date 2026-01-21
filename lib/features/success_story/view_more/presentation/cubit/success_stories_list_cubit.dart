import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnav/features/success_story/domain/repositories/post_type_enum.dart';

import '../../data/success_stories_list_remote_ds.dart';
import '../../data/success_story_list_item_model.dart';
import '../../domain/success_story_filter.dart';
import 'success_stories_list_state.dart';

class SuccessStoriesListCubit extends Cubit<SuccessStoriesListState> {
  final SuccessStoriesListRemoteDS remote;

  static const int _pageSize = 10;

  int _from = 0;
  bool _hasMore = true;

  SuccessStoryFilter _filter = SuccessStoryFilter.all;
  String _searchQuery = '';

  Timer? _debounce;

  SuccessStoriesListCubit(this.remote)
      : super(SuccessStoriesListLoading());

  /* -------------------------------------------------------
   * PUBLIC API
   * ----------------------------------------------------- */

  Future<void> init() async {
    await _reload();
  }

  void onFilterChanged(SuccessStoryFilter filter) {
    if (_filter == filter) return;
    _filter = filter;
    _reload();
  }

  void onSearchChanged(String q) {
    _searchQuery = q;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _reload();
    });
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! SuccessStoriesListLoaded) return;
    if (current.isLoadingMore || !_hasMore) return;

    emit(current.copyWith(isLoadingMore: true));

    try {
      final nextFrom = _from + _pageSize;
      final nextTo = nextFrom + _pageSize - 1;

      final raw = await remote.fetch(
        from: nextFrom,
        to: nextTo,
      );

      final fetched = raw
          .map(SuccessStoryListItemModel.fromMap)
          .toList();

      _from = nextFrom;
      _hasMore = fetched.length == _pageSize;

      final visible = _applyFilterAndSearch(fetched);

      emit(
        current.copyWith(
          stories: [...current.stories, ...visible],
          isLoadingMore: false,
          hasMore: _hasMore,
        ),
      );
    } catch (e) {
      emit(current.copyWith(isLoadingMore: false));
    }
  }

  /* -------------------------------------------------------
   * INTERNAL LOGIC
   * ----------------------------------------------------- */

  Future<void> _reload() async {
    emit(SuccessStoriesListLoading());

    try {
      _from = 0;
      _hasMore = true;

      final raw = await remote.fetch(
        from: 0,
        to: _pageSize - 1,
      );

      final all = raw
          .map(SuccessStoryListItemModel.fromMap)
          .toList();

      final visible = _applyFilterAndSearch(all);
      _hasMore = all.length == _pageSize;

      emit(
        SuccessStoriesListLoaded(
          stories: visible,
          filter: _filter,
          searchQuery: _searchQuery,
          isLoadingMore: false,
          hasMore: _hasMore,
        ),
      );
    } catch (e) {
      emit(SuccessStoriesListError(e.toString()));
    }
  }

  List<SuccessStoryListItemModel> _applyFilterAndSearch(
      List<SuccessStoryListItemModel> input,
      ) {
    return input.where((e) {
      // FILTER
      final matchesFilter = switch (_filter) {
        SuccessStoryFilter.adopted =>
        e.postType == PostType.adopted,

        SuccessStoryFilter.reunited =>
        e.postType == PostType.lost ||
            e.postType == PostType.found,

        SuccessStoryFilter.all => true,
      };

      if (!matchesFilter) return false;

      // SEARCH (case-insensitive)
      if (_searchQuery.trim().isEmpty) return true;

      final q = _searchQuery.toLowerCase();
      return e.title.toLowerCase().contains(q) ||
          e.description.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
