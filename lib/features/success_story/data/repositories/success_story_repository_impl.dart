import 'package:pawnav/features/success_story/data/repositories/success_story_repository_impl.dart';
import 'package:pawnav/features/success_story/domain/entities/success_story_detail_entity.dart';

import '../../domain/repositories/success_story_repository.dart';
import '../datasources/success_story_remote_datasource.dart';
import '../models/profile_model.dart';

class SuccessStoryRepositoryImpl implements SuccessStoryRepository {
  final SuccessStoryRemoteDataSource remote;
  SuccessStoryRepositoryImpl(this.remote);

  @override
  Future<Map<String, dynamic>> getPostById(String postId) => remote.getPostById(postId);

  @override
  Future<ProfileModel> getProfileById(String userId) async {
    final map = await remote.getProfileById(userId);
    return ProfileModel.fromMap(map);
  }

  @override
  Future<List<ProfileModel>> searchProfiles(String query) async {
    final list = await remote.searchProfiles(query);
    return list.map(ProfileModel.fromMap).toList();
  }
  @override
  Future<SuccessStoryDetailEntity> getStoryDetail(String storyId) async {
    final data = await remote.getStoryDetail(storyId);
    return data;
  }


  //Success story oluştur
  @override
  Future<void> createSuccessStory({
    required String postId,
    required String ownerId,
    required String story,
    String? heroId,
  }) =>
      remote.createSuccessStory(
        postId: postId,
        ownerId: ownerId,
        story: story,
        heroId: heroId,
      );

}
