import '../../data/models/profile_model.dart';

abstract class SuccessStoryRepository {
  Future<Map<String, dynamic>> getPostById(String postId);
  Future<ProfileModel> getProfileById(String userId);
  Future<List<ProfileModel>> searchProfiles(String query);

  Future<void> createSuccessStory({
    required String postId,
    required String ownerId,
    required String story,
    String? heroId,
  });
}
