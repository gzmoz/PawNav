import 'package:pawnav/features/success_story/data/models/profile_model.dart';
import 'package:pawnav/features/success_story/data/models/success_story_model.dart';

sealed class SuccessStoryDetailState {}

class SuccessStoryDetailLoading extends SuccessStoryDetailState {}

class SuccessStoryDetailError extends SuccessStoryDetailState {
  final String message;
  SuccessStoryDetailError(this.message);
}
class SuccessStoryDetailLoaded extends SuccessStoryDetailState {
  final SuccessStoryModel story;

  final String petName;
  final String species;
  final String breed;
  final int? age;
  final String coverImageUrl;
  final bool isAdopted;

  /// 👇 Timeline
  final DateTime lostDate;
  final DateTime reunitedDate;

  final ProfileModel owner;
  final ProfileModel? hero;

  SuccessStoryDetailLoaded({
    required this.story,
    required this.petName,
    required this.species,
    required this.breed,
    required this.coverImageUrl,
    required this.isAdopted,
    required this.lostDate,
    required this.reunitedDate,
    required this.owner,
    this.hero,
    this.age,
  });
}

// class SuccessStoryDetailLoaded extends SuccessStoryDetailState {
//   final SuccessStoryModel story;
//
//   // UI için resolve edilmiş alanlar
//   final String petName;
//   final String species;
//   final String breed;
//   final int? age;
//   final String coverImageUrl;
//   final bool isAdopted;
//
//   final ProfileModel owner;
//   final ProfileModel? hero;
//
//   SuccessStoryDetailLoaded({
//     required this.story,
//     required this.petName,
//     required this.species,
//     required this.breed,
//     required this.coverImageUrl,
//     required this.isAdopted,
//     required this.owner,
//     this.hero,
//     this.age,
//   });
// }
