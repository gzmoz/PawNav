import 'package:pawnav/features/home/data/models/recent_post_model.dart';

abstract class RecentActivityState {}

class RecentActivityInitial extends RecentActivityState {}

class RecentActivityLoading extends RecentActivityState {}

class RecentActivityLoaded extends RecentActivityState {
  final List<RecentPostModel> posts;
  RecentActivityLoaded(this.posts);
}

class RecentActivityError extends RecentActivityState {
  final String message;
  RecentActivityError(this.message);
}
