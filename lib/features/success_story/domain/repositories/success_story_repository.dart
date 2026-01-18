import 'package:pawnav/features/success_story/domain/entities/success_story_detail_entity.dart';

import '../../data/models/profile_model.dart';

abstract class SuccessStoryRepository {
  Future<Map<String, dynamic>> getPostById(String postId);
  Future<ProfileModel> getProfileById(String userId);
  Future<List<ProfileModel>> searchProfiles(String query);
  Future<SuccessStoryDetailEntity> getStoryDetail(String storyId);
  Future<void> deleteStory(String storyId);


  Future<void> createSuccessStory({
    required String postId,
    required String ownerId,
    required String story,
    String? heroId,
  });
}
