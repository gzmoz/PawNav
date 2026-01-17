import 'package:postgrest/src/types.dart';

class SuccessStoryModel {
  final String id;
  final String postId;
  final String ownerId;
  final String? heroId;
  final String story;


  SuccessStoryModel({
    required this.id,
    required this.postId,
    required this.ownerId,
    required this.story,
    this.heroId,
  });


  Map<String, dynamic> toInsertMap() => {
    'post_id': postId,
    'owner_id': ownerId,
    'hero_id': heroId,
    'story': story,
  };

  static SuccessStoryModel fromMap(PostgrestMap map) {
    return SuccessStoryModel(
      id: map['id'],
      postId: map['post_id'],
      ownerId: map['owner_id'],
      heroId: map['hero_id'],
      story: map['story'],
    );
  }
}
