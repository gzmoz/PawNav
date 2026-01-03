//Supabase’ten badge verisini çekip, uygulamanın kullanabileceği modele dönüştürmek
import 'package:pawnav/features/badges/data/models/badge_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BadgeRemoteDataSource {
  final SupabaseClient supabase;

  BadgeRemoteDataSource(this.supabase);

  Future<List<BadgeModel>> fetchAllBadges() async {
    final res = await supabase
        .from('badges')
        .select('id, key, name, description, icon_url')
        .order('created_at');

    return (res as List)
        .map((e) => BadgeModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Set<String>> fetchUserBadgeIds(String userId) async {
    final res = await supabase
        .from('user_badges')
        .select('badge_id')
        .eq('user_id', userId);

    return (res as List)
        .map((e) => (e as Map<String, dynamic>)['badge_id'] as String)
        .toSet();
  }
}
