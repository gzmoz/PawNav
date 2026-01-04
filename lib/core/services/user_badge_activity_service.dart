import 'package:supabase_flutter/supabase_flutter.dart';

class UserActivityService {
  final SupabaseClient _client;
  UserActivityService(this._client);

  String get _uid => _client.auth.currentUser!.id;

  Future<List<String>> checkAndAward() async {
    final res = await _client.rpc(
      'check_and_award_badges',
      params: {'p_user_id': _uid},
    );

    if (res == null) return [];

    return (res as List)
        .map((e) => (e as Map<String, dynamic>)['badge_id'] as String)
        .toList();
  }

  Future<List<String>> postCreated() async {
    await _client.rpc('inc_post_created');
    return checkAndAward();
  }

  Future<List<String>> mapOpened() async {
    await _client.rpc('inc_map_open');
    return checkAndAward();
  }

  Future<List<String>> shared() async {
    await _client.rpc('inc_share');
    return checkAndAward();
  }

  Future<List<String>> reunion() async {
    await _client.rpc('inc_reunion');
    return checkAndAward();
  }

  Future<List<String>> helpAction() async {
    await _client.rpc('inc_help_action');
    return checkAndAward();
  }

  Future<List<String>> dailyActive() async {
    await _client.rpc('record_daily_activity');
    return checkAndAward();
  }
}
