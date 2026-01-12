import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/models/profile_model.dart';
import '../../domain/usecases/create_success_story.dart';
import '../../domain/usecases/search_profiles.dart';
import '../../domain/repositories/success_story_repository.dart';
import 'write_success_story_state.dart';

class WriteSuccessStoryCubit extends Cubit<WriteSuccessStoryState> {
  final SuccessStoryRepository repo;
  final CreateSuccessStory createStory;
  final SearchProfiles searchProfiles;
  final SupabaseClient supabase;

  WriteSuccessStoryCubit({
    required this.repo,
    required this.createStory,
    required this.searchProfiles,
    required this.supabase,
  }) : super(WriteSuccessStoryInitial());

  Future<void> init(String postId) async {
    try {
      emit(WriteSuccessStoryLoading());

      final post = await repo.getPostById(postId);

      final ownerId = post['user_id'] as String;
      final owner = await repo.getProfileById(ownerId);

      final petName = (post['name'] as String?)?.trim().isNotEmpty == true
          ? post['name'] as String
          : 'Pet';

      String? cover;

      final images = post['images'];

      if (images is List && images.isNotEmpty) {
        cover = images.first as String?;
      } else if (images is String && images.isNotEmpty) {
        cover = images;
      } else {
        cover = null;
      }


      // Status label örneği: post_type'dan türet
      final postType = (post['post_type'] as String?) ?? '';
      final statusLabel = postType.toLowerCase().contains('adopt')
          ? 'ADOPTED!'
          : 'REUNITED!';

      emit(
        WriteSuccessStoryLoaded(
          postId: postId,
          petName: petName,
          species: post['species'] as String?,
          breed: post['breed'] as String?,
          coverImageUrl: cover,
          statusLabel: statusLabel,
          owner: owner,
          hero: null,
          story: '',
          maxChars: 1000,
          isPublishing: false,
        ),
      );

    } catch (e) {
      emit(WriteSuccessStoryError(e.toString()));
    }
  }

  void onStoryChanged(String value) {
    final s = state;
    if (s is! WriteSuccessStoryLoaded) return;

    final trimmed = value; // UI’de limit yapacağız
    emit(s.copyWith(story: trimmed));
  }

  void setHero(ProfileModel? hero) {
    final s = state;
    if (s is! WriteSuccessStoryLoaded) return;
    emit(s.copyWith(hero: hero));
  }

  Future<List<ProfileModel>> searchPeople(String query) {
    return searchProfiles(query);
  }

  Future<void> publish() async {
    final s = state;
    if (s is! WriteSuccessStoryLoaded) return;
    if (!s.canPublish) return;

    final currentUserId = supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      emit(WriteSuccessStoryError('Not authenticated'));
      return;
    }

    try {
      emit(s.copyWith(isPublishing: true));

      // owner_id = post owner (s.owner.id). RLS zaten sadece owner insert allow ediyor.
      await createStory(
        postId: s.postId,
        ownerId: s.owner.id,
        heroId: s.hero?.id,
        story: s.story.trim(),
      );

      emit(WriteSuccessStorySuccess());
    } catch (e) {
      emit(WriteSuccessStoryError(e.toString()));
    }
  }
}
