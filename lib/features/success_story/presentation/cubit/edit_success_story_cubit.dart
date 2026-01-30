import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnav/features/success_story/data/models/profile_model.dart';
import 'package:pawnav/features/success_story/domain/repositories/post_type_enum.dart';
import 'package:pawnav/features/success_story/domain/repositories/success_story_repository.dart';
import 'package:pawnav/features/success_story/domain/usecases/search_profiles.dart';
import 'package:pawnav/features/success_story/presentation/cubit/edit_success_story_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditSuccessStoryCubit extends Cubit<EditSuccessStoryState> {
  final SuccessStoryRepository repo;
  final SearchProfiles searchProfiles;
  final SupabaseClient supabase;

  EditSuccessStoryCubit({
    required this.repo,
    required this.searchProfiles,
    required this.supabase,
  }) : super(EditSuccessStoryLoading());

  Future<void> init(String storyId) async {
    try {
      emit(EditSuccessStoryLoading());

      final detail = await repo.getStoryDetail(storyId);

      emit(
        EditSuccessStoryLoaded(
          storyId: detail.story.id,
          postId: detail.story.postId,
          petName: detail.petName,
          species: detail.species,
          breed: detail.breed,
          coverImageUrl: detail.coverImageUrl,
          statusLabel: detail.postType == PostType.adopted
              ? 'ADOPTED!'
              : 'REUNITED!',
          owner: detail.owner,
          hero: detail.hero,
          story: detail.story.story,
          maxChars: 1000,
          isSaving: false,
        ),
      );
    } catch (e) {
      emit(EditSuccessStoryError(e.toString()));
    }
  }

  void onStoryChanged(String value) {
    final s = state;
    if (s is! EditSuccessStoryLoaded) return;
    emit(s.copyWith(story: value));
  }

  void setHero(ProfileModel? hero) {
    final s = state;
    if (s is! EditSuccessStoryLoaded) return;
    emit(s.copyWith(hero: hero));
  }

  Future<List<ProfileModel>> searchPeople(String q) async {
    return await repo.searchProfiles(q);
  }



  /*Future<List<ProfileModel>> searchPeople(String q) {
    return searchProfiles(q);
  }*/

  Future<void> save() async {
    final s = state;
    if (s is! EditSuccessStoryLoaded || !s.canSave) return;

    try {
      emit(s.copyWith(isSaving: true));

      await supabase
          .from('success_stories')
          .update({
        'story': s.story.trim(),
        'hero_id': s.hero?.id,
      })
          .eq('id', s.storyId);

      emit(EditSuccessStorySuccess());
    } catch (e) {
      emit(EditSuccessStoryError(e.toString()));
    }
  }


}
