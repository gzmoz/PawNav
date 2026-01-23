import 'package:pawnav/features/map/data/datasources/map_remote_datasource.dart';
import 'package:pawnav/features/map/domain/entities/map_post.dart';

abstract class MapRepository {
  Future<List<MapPost>> getNearbyPosts({
    required double lat,
    required double lon,
    required double radiusKm,
  });
}

class MapRepositoryImpl implements MapRepository {
  final MapRemoteDataSource remote;

  MapRepositoryImpl(this.remote);

  @override
  Future<List<MapPost>> getNearbyPosts({
    required double lat,
    required double lon,
    required double radiusKm,
  }) {
    return remote.getPostsWithinRadius(
      lat: lat,
      lon: lon,
      radiusKm: radiusKm,
    );
  }
}
