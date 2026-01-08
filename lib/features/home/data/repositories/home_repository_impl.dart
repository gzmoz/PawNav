import 'package:pawnav/features/home/domain/repositories/home_repository.dart';
import 'package:pawnav/features/post/data/models/post_model.dart';
import 'package:pawnav/features/post/domain/entities/post.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeRepositoryImpl implements HomeRepository {
  final SupabaseClient client;

  HomeRepositoryImpl(this.client);

  @override
  Future<List<Post>> getPostsByViews({
    required int limit,
    int? lastViews,
    String? lastId,
  }) async {
    // 1) En çok views alanlar üstte, aynı views varsa id ile sabitle
    dynamic query = client
        .from('posts')
        .select()
        .order('views', ascending: false)
        .order('id', ascending: false)
        .limit(limit);

    // 2) Cursor pagination:
    // (views < lastViews) OR (views = lastViews AND id < lastId)
    if (lastViews != null && lastId != null) {
      query = query.or(
        'views.lt.$lastViews,and(views.eq.$lastViews,id.lt.$lastId)',
      );
    }

    final response = await query;

    return (response as List)
        .map((e) => PostModel.fromMap(e))
        .toList();
  }
}
