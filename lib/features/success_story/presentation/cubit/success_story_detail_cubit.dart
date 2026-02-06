import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnav/features/success_story/domain/repositories/success_story_repository.dart';
import 'package:pawnav/features/success_story/presentation/cubit/success_story_detail_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SuccessStoryDetailCubit extends Cubit<SuccessStoryDetailState> {
  final SuccessStoryRepository repository;

  SuccessStoryDetailCubit(this.repository)
      : super(SuccessStoryDetailLoading());

  Future<void> load(String storyId) async {
    try {
      emit(SuccessStoryDetailLoading());

      final data = await repository.getStoryDetail(storyId);

      final currentUserId =
          Supabase.instance.client.auth.currentUser?.id;

      final bool isOwner =
          currentUserId != null &&
              currentUserId == data.story.ownerId;

      emit(
        SuccessStoryDetailLoaded(
          story: data.story,
          petName: data.petName,
          species: data.species,
          breed: data.breed,
          age: data.age,
          coverImageUrl: data.coverImageUrl,
          isAdopted: data.isAdopted,
          owner: data.owner,
          hero: data.hero,
          lostDate: data.lostDate,
          reunitedDate: data.reunitedDate,
          postType: data.postType,
          location: data.location,
          isOwner: isOwner,

        ),
      );

    } catch (e) {
      emit(SuccessStoryDetailError(e.toString()));
    }
  }

  Future<void> deleteStory({
    required String storyId,
    required String postId,
  }) async {
    try {
      await repository.deleteStory(
        storyId: storyId,
        postId: postId,
      );
      emit(SuccessStoryDeleted());
    } catch (e) {
      emit(SuccessStoryDetailError(e.toString()));
    }
  }


/*Future<void> deleteStory(String storyId) async {
    try {
      await repository.deleteStory(storyId);
      emit(SuccessStoryDeleted());
    } catch (e) {
      emit(SuccessStoryDetailError(e.toString()));
    }
  }*/

}
