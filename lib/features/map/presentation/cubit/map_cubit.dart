import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnav/features/map/domain/entities/map_filter.dart';
import 'package:pawnav/features/map/domain/entities/map_post.dart';
import 'package:pawnav/features/map/domain/repositories/map_repository.dart';
import 'package:pawnav/features/map/presentation/cubit/map_state.dart';

class MapCubit extends Cubit<MapState> {
  final MapRepository repo;

  MapCubit(this.repo) : super(MapInitial());

  Future<void> loadNearby({
    required double lat,
    required double lon,
    double radiusKm = 10,
    MapFilter filter = MapFilter.empty,
  }) async {
    emit(MapLoading());

    final previousSelected =
        state is MapLoaded ? (state as MapLoaded).selectedPost : null;

    final posts = await repo.getNearbyPosts(
      lat: lat,
      lon: lon,
      radiusKm: radiusKm,
      filter: filter,
    );

    emit(
      MapLoaded(
        posts: posts,
        selectedPost: previousSelected,
      ),
    );
  }

  void selectPost(MapPost post) {
    final current = state;
    if (current is MapLoaded) {
      emit(
        current.copyWith(
          selectedPost: post,
        ),
      );
    }
  }

  void clearSelection() {
    final current = state;
    if (current is MapLoaded) {
      emit(
        current.copyWith(
          selectedPost: null,
        ),
      );
    }
  }
}
