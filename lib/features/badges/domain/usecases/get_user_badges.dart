import 'package:pawnav/features/badges/domain/repositories/badge_repository.dart';

class GetUserBadgeIds {
  final BadgeRepository repo;

  GetUserBadgeIds(this.repo);

  Future<Set<String>> call() => repo.getUserBadgeIds();
}
