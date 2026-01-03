import 'package:equatable/equatable.dart';

import '../../domain/entities/badge_entity.dart';

import '../../domain/entities/badge_entity.dart';
import '../../domain/entities/user_rank.dart';


class BadgesState {
  final bool isLoading;
  final List<BadgeEntity> badges;
  final Set<String> userBadgeIds;
  final String? error;

  const BadgesState({
    required this.isLoading,
    required this.badges,
    required this.userBadgeIds,
    this.error,
  });

  factory BadgesState.initial() =>
      const BadgesState(isLoading: true, badges: [], userBadgeIds: {});

  int get earnedCount => badges.where((b) => userBadgeIds.contains(b.id)).length;
  int get totalCount => badges.length;
  double get progress => totalCount == 0 ? 0 : earnedCount / totalCount;
}
