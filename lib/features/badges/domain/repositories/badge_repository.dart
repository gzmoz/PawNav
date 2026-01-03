import 'package:pawnav/features/badges/domain/entities/badge_entity.dart';

abstract class BadgeRepository {
  Future<List<BadgeEntity>> getAllBadges();

  Future<Set<String>> getUserBadgeIds();
}
