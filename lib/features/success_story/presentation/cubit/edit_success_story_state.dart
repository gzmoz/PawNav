import 'package:pawnav/features/success_story/data/models/profile_model.dart';

sealed class EditSuccessStoryState {}

class EditSuccessStoryLoading extends EditSuccessStoryState {}

class EditSuccessStoryLoaded extends EditSuccessStoryState {
  final String storyId;
  final String postId;

  final String petName;
  final String? species;
  final String? breed;
  final String? coverImageUrl;
  final String statusLabel;

  final ProfileModel owner;
  final ProfileModel? hero;

  final String story;
  final int maxChars;

  final bool isSaving;

  EditSuccessStoryLoaded({
    required this.storyId,
    required this.postId,
    required this.petName,
    required this.species,
    required this.breed,
    required this.coverImageUrl,
    required this.statusLabel,
    required this.owner,
    required this.hero,
    required this.story,
    required this.maxChars,
    required this.isSaving,
  });

  bool get canSave => story.trim().length >= 20;

  EditSuccessStoryLoaded copyWith({
    String? story,
    ProfileModel? hero,
    bool? isSaving,
  }) {
    return EditSuccessStoryLoaded(
      storyId: storyId,
      postId: postId,
      petName: petName,
      species: species,
      breed: breed,
      coverImageUrl: coverImageUrl,
      statusLabel: statusLabel,
      owner: owner,
      hero: hero ?? this.hero,
      story: story ?? this.story,
      maxChars: maxChars,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class EditSuccessStorySuccess extends EditSuccessStoryState {}

class EditSuccessStoryError extends EditSuccessStoryState {
  final String message;
  EditSuccessStoryError(this.message);
}
