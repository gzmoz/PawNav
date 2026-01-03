import 'package:pawnav/features/badges/domain/entities/badge_entity.dart';
import 'package:pawnav/features/badges/domain/repositories/badge_repository.dart';

class GetAllBadges {
  final BadgeRepository repo;

  GetAllBadges(this.repo);

  Future<List<BadgeEntity>> call() => repo.getAllBadges();
}
