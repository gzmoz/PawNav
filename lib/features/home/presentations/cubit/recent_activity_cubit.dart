import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnav/features/home/domain/repositories/recent_activity_repository.dart';
import 'package:pawnav/features/home/presentations/cubit/recent_activity_state.dart';

class RecentActivityCubit extends Cubit<RecentActivityState> {
  final RecentActivityRepository repository;

  RecentActivityCubit(this.repository)
      : super(RecentActivityInitial());

  Future<void> fetchPreview() async {
    emit(RecentActivityLoading());
    try {
      final posts = await repository.getPreviewPosts();
      emit(RecentActivityLoaded(posts));
    } catch (e) {
      emit(RecentActivityError(e.toString()));
    }
  }

  Future<void> fetchAll() async {
    emit(RecentActivityLoading());
    try {
      final posts = await repository.getAllRecentPosts();
      emit(RecentActivityLoaded(posts));
    } catch (e) {
      emit(RecentActivityError(e.toString()));
    }
  }
}



/*class RecentActivityCubit extends Cubit<RecentActivityState> {
  final RecentActivityRepository repository;

  RecentActivityCubit(this.repository)
      : super(RecentActivityInitial());

  Future<void> fetchRecentPosts() async {
    emit(RecentActivityLoading());
    try {
      final posts = await repository.getRecentPosts();
      emit(RecentActivityLoaded(posts));
    } catch (e) {
      emit(RecentActivityError(e.toString()));
    }
  }
}*/
