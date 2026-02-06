import 'package:pawnav/features/post/domain/entities/post_filter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class PostRemoteDataSource {
  final SupabaseClient client;

  PostRemoteDataSource(this.client);

  Future<List<Map<String, dynamic>>> getPosts({
    PostFilter filter = PostFilter.empty,
  }) async {

    // RADIUS VARSA → RPC
    if (filter.lat != null &&
        filter.lon != null &&
        filter.radiusKm != null) {

      final res = await client.rpc(
        'get_posts_within_radius',
        params: {
          'user_lat': filter.lat,
          'user_lon': filter.lon,
          'radius_km': filter.radiusKm,
          'post_type_filter': filter.postType,
          'species_filter': filter.animal,
          'breed_filter': filter.breed,
        },
      );




      return (res as List).cast<Map<String, dynamic>>();
    }

    //  NORMAL QUERY
    var query = client.from('posts').select('''
      id,
      user_id,
      species,
      breed,
      color,
      gender,
      name,
      description,
      location,
      event_date,
      images,
      post_type,
      views,
      is_active,
      profiles (
        id,
        name,
        username,
        photo_url
      )
    ''');

    if (filter.postType != null && filter.postType!.isNotEmpty) {
      query = query.eq('post_type', filter.postType!);
    }

    if (filter.animal != null && filter.animal!.isNotEmpty) {
      query = query.eq('species', filter.animal!);
    }

    if (filter.breed != null &&
        filter.breed!.isNotEmpty &&
        filter.breed != 'Any') {
      query = query.eq('breed', filter.breed!);
    }

    if (filter.location != null && filter.location!.isNotEmpty) {
      query = query.ilike('location', '%${filter.location!}%');
    }

    final res = await query.order('created_at', ascending: false);

    return (res as List).cast<Map<String, dynamic>>();
  }
}
/*final res = await client.rpc(
        'get_posts_within_radius',
        params: {
          'user_lat': filter.lat,
          'user_lon': filter.lon,
          'radius_km': filter.radiusKm,
        },
      );*/






