import 'package:pawnav/features/badges/data/datasources/badge_remote_datasource.dart';
import 'package:pawnav/features/badges/domain/entities/badge_entity.dart';
import 'package:pawnav/features/badges/domain/repositories/badge_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BadgeRepositoryImpl implements BadgeRepository{
  final BadgeRemoteDataSource remote;
  final SupabaseClient supabase;

  BadgeRepositoryImpl(this.remote, this.supabase);

  @override
  Future<List<BadgeEntity>> getAllBadges() => remote.fetchAllBadges();

  @override
  Future<Set<String>> getUserBadgeIds() {
    final userId = supabase.auth.currentUser!.id;
    return remote.fetchUserBadgeIds(userId);
  }
}