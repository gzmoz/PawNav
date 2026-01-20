import 'package:pawnav/features/home/data/models/recent_post_model.dart';
import 'package:pawnav/features/home/domain/repositories/recent_activity_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecentActivityRepositoryImpl
    implements RecentActivityRepository {
  final SupabaseClient supabase;

  static const int _previewLimit = 5;
  static const int _fullLimit = 50;

  RecentActivityRepositoryImpl(this.supabase);

  @override
  Future<List<RecentPostModel>> getPreviewPosts() async {
    return _fetch(limit: _previewLimit);
  }

  @override
  Future<List<RecentPostModel>> getAllRecentPosts() async {
    return _fetch(limit: _fullLimit);
  }

  Future<List<RecentPostModel>> _fetch({required int limit}) async {
    final response = await supabase
        .from('posts')
        .select('id, name, location, images, created_at, post_type')
        .eq('is_active', true)
        .order('created_at', ascending: false)
        .limit(limit);

    return (response as List)
        .map((e) => RecentPostModel.fromJson(e))
        .toList();
  }
}


