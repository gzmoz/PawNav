import '../../data/models/profile_model.dart';
import '../repositories/success_story_repository.dart';

class SearchProfiles {
  final SuccessStoryRepository repo;
  SearchProfiles(this.repo);

  Future<List<ProfileModel>> call(String query) => repo.searchProfiles(query);
}
