import 'package:pawnav/features/success_story/data/models/profile_model.dart';
import 'package:pawnav/features/success_story/data/models/success_story_model.dart';

class SuccessStoryDetailEntity {
  final SuccessStoryModel story;
  final String petName;
  final String species;
  final String breed;
  final int? age;
  final String coverImageUrl;
  final bool isAdopted;
  final ProfileModel owner;
  final ProfileModel? hero;

  SuccessStoryDetailEntity({
    required this.story,
    required this.petName,
    required this.species,
    required this.breed,
    required this.coverImageUrl,
    required this.isAdopted,
    required this.owner,
    this.hero,
    this.age,
  });
}
