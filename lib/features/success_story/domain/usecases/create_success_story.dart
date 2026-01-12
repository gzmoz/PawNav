import '../repositories/success_story_repository.dart';

class CreateSuccessStory {
  final SuccessStoryRepository repo;
  CreateSuccessStory(this.repo);

  Future<void> call({
    required String postId,
    required String ownerId,
    required String story,
    String? heroId,
  }) {
    return repo.createSuccessStory(
      postId: postId,
      ownerId: ownerId,
      story: story,
      heroId: heroId,
    );
  }
}
