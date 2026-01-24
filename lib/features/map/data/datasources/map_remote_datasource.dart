import 'package:flutter/cupertino.dart';
import 'package:pawnav/features/map/domain/entities/map_filter.dart';
import 'package:pawnav/features/map/domain/entities/map_post.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MapRemoteDataSource {
  final SupabaseClient client;

  MapRemoteDataSource(this.client);

  Future<List<MapPost>> getPostsWithinRadius({
    required double lat,
    required double lon,
    required double radiusKm,
    MapFilter filter = MapFilter.empty,
  }) async {
    final res = await client.rpc(
      'get_map_posts_within_radius',
      params: {
        'user_lat': lat,
        'user_lon': lon,
        'radius_km': radiusKm,
        'post_type_filter': filter.postType,
        'animal_filter': filter.animal,
        'breed_filter': filter.breed,
      },
    );

    debugPrint('MAP RPC RAW RESPONSE: $res');



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