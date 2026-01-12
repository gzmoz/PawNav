import '../../data/models/profile_model.dart';

/*sealed şunu söyler:
“Bu state’in tüm alt türleri bu dosyada tanımlıdır.
Başka yerden yeni state eklenemez.”*/
sealed class WriteSuccessStoryState {}

class WriteSuccessStoryInitial extends WriteSuccessStoryState {}

class WriteSuccessStoryLoading extends WriteSuccessStoryState {}

class WriteSuccessStoryLoaded extends WriteSuccessStoryState {
  final String postId;

  // Post context (minimal)
  final String petName;
  final String? species;
  final String? breed;
  final String? coverImageUrl;
  final String statusLabel; // "REUNITED!" gibi

  // People
  final ProfileModel owner;
  final ProfileModel? hero;

  // Draft
  final String story;
  final int maxChars;

  // UI flags
  final bool isPublishing;

  WriteSuccessStoryLoaded({
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
    required this.isPublishing,
  });

  bool get canPublish => story.trim().length >= 20; // db check ile uyumlu

  WriteSuccessStoryLoaded copyWith({
    ProfileModel? hero,
    String? story,
    bool? isPublishing,
  }) {
    return WriteSuccessStoryLoaded(
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
      isPublishing: isPublishing ?? this.isPublishing,
    );
  }
}

class WriteSuccessStorySuccess extends WriteSuccessStoryState {}

class WriteSuccessStoryError extends WriteSuccessStoryState {
  final String message;
  WriteSuccessStoryError(this.message);
}
