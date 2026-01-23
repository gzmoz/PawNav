import 'package:pawnav/features/map/domain/entities/map_post.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MapRemoteDataSource {
  final SupabaseClient client;

  MapRemoteDataSource(this.client);

  Future<List<MapPost>> getPostsWithinRadius({
    required double lat,
    required double lon,
    required double radiusKm,
  }) async {
    final res = await client.rpc(
      'get_posts_within_radius',
      params: {
        'user_lat': lat,
        'user_lon': lon,
        'radius_km': radiusKm,
      },
    );

    final List data = res as List;

    return data.map((e) {
      return MapPost(
        id: e['id'],
        lat: e['lat'],
        lon: e['lon'],
        postType: e['post_type'],
        location: e['location'],
        images: List<String>.from(e['images'] ?? []),
        name: e['name'],
      );
    }).toList();
  }
}
