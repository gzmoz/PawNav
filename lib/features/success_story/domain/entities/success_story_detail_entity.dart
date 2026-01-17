import 'package:pawnav/features/success_story/data/models/profile_model.dart';
import 'package:pawnav/features/success_story/data/models/success_story_model.dart';
import 'package:pawnav/features/success_story/domain/repositories/post_type_enum.dart';

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
  final DateTime lostDate;      // post created_at
  final DateTime reunitedDate;  // success_story created_at
  final PostType postType;
  final String? location;



  SuccessStoryDetailEntity({
    required this.story,
    required this.petName,
    required this.species,
    required this.breed,
    required this.coverImageUrl,
    required this.isAdopted,
    required this.owner,
    required this.lostDate,
    required this.reunitedDate,
    required this.postType,
    this.location,
    this.hero,
    this.age,
  });

  String get initialTimelineText {
    switch (postType) {
      case PostType.lost:
        return "Reported Lost in $location";
      case PostType.found:
        return "Reported Found in $location";
      case PostType.adopted:
        return "Put Up for Adoption in $location";
    }
  }

  String get finalTimelineText {
    switch (postType) {
      case PostType.adopted:
        return "Successfully Adopted";
      default:
        return "Safely Reunited with Family";
    }
  }


}
