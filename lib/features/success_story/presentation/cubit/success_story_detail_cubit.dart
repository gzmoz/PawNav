import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnav/features/success_story/domain/repositories/success_story_repository.dart';
import 'package:pawnav/features/success_story/presentation/cubit/success_story_detail_state.dart';

class SuccessStoryDetailCubit extends Cubit<SuccessStoryDetailState> {
  final SuccessStoryRepository repository;

  SuccessStoryDetailCubit(this.repository)
      : super(SuccessStoryDetailLoading());

  Future<void> load(String storyId) async {
    try {
      emit(SuccessStoryDetailLoading());

      final data = await repository.getStoryDetail(storyId);

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
        ),
      );
    } catch (e) {
      emit(SuccessStoryDetailError(e.toString()));
    }
  }
}
