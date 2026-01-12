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
}
