import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnav/features/success_story/data/models/account_success_story_item.dart';
import 'package:pawnav/features/success_story/data/models/success_story_model.dart';
import 'package:pawnav/features/success_story/presentation/cubit/account_success_stories_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



class AccountSuccessStoriesCubit
    extends Cubit<AccountSuccessStoriesState> {
  final SupabaseClient supabase;

  AccountSuccessStoriesCubit(this.supabase)
      : super(AccountSuccessStoriesInitial());

  Future<void> loadMySuccessStories() async {
    try {
      emit(AccountSuccessStoriesLoading());

      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        emit(AccountSuccessStoriesLoaded([]));
        return;
      }

      final response = await supabase
          .from('success_stories')
          .select('''
            id,
            post_id,
            owner_id,
            hero_id,
            story,
            posts (
              name,
              images,
              post_type
            )
          ''')
          .eq('owner_id', userId)
          .order('created_at', ascending: false);

      final items = (response as List).map((row) {
        final story = SuccessStoryModel(
          id: row['id'],
          postId: row['post_id'],
          ownerId: row['owner_id'],
          heroId: row['hero_id'],
          story: row['story'],
        );

        final post = row['posts'];
        final images = post?['images'];

        String? cover;
        if (images is List && images.isNotEmpty) {
          cover = images.first;
        } else if (images is String && images.isNotEmpty) {
          cover = images;
        }

        final postType = (post?['post_type'] as String?) ?? '';
        final isAdopted = postType.toLowerCase().contains('adopt');

        return AccountSuccessStoryItem(
          story: story,
          petName: post?['name'] ?? 'Pet',
          imageUrl: cover,
          isAdopted: isAdopted,
        );
      }).toList();

      emit(AccountSuccessStoriesLoaded(items));
    } catch (e) {
      emit(AccountSuccessStoriesError(e.toString()));
    }
  }

  Future<void> refresh() async {
    emit(AccountSuccessStoriesLoading());
    await loadMySuccessStories();
  }

  void removeStory(String storyId) {
    if (state is! AccountSuccessStoriesLoaded) return;

    final current = state as AccountSuccessStoriesLoaded;

    final updatedStories =
    current.stories.where((s) => s.story.id != storyId).toList();

    emit(AccountSuccessStoriesLoaded(updatedStories));
  }






}
