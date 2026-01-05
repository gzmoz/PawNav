import 'package:pawnav/features/home/data/models/recent_post_model.dart';

abstract class RecentActivityRepository {
  Future<List<RecentPostModel>> getRecentPosts();
}
