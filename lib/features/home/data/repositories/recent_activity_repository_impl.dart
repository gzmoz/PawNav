import 'package:pawnav/features/home/data/models/recent_post_model.dart';
import 'package:pawnav/features/home/domain/repositories/recent_activity_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecentActivityRepositoryImpl
    implements RecentActivityRepository {
  final SupabaseClient supabase;

  RecentActivityRepositoryImpl(this.supabase);

  @override
  Future<List<RecentPostModel>> getRecentPosts() async {
    final response = await supabase
        .from('posts')
        .select('id, name, location, images, created_at, post_type')
        .order('created_at', ascending: false)
        .limit(5);

    print('RAW RESPONSE: $response');


    return (response as List)
        .map((e) => RecentPostModel.fromJson(e))
        .toList();


  }
}
