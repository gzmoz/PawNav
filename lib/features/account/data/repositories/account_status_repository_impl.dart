import 'package:flutter/cupertino.dart';
import 'package:pawnav/features/account/data/models/account_status_model.dart';
import 'package:pawnav/features/account/domain/repositories/account_status_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountStatsRepositoryImpl implements AccountStatsRepository {
  final SupabaseClient supabase;

  AccountStatsRepositoryImpl(this.supabase);

  @override
  Future<AccountStats> getStats() async {
    final res = await supabase.rpc('get_account_stats');
    debugPrint('ACCOUNT STATS RAW: $res');
    return AccountStats.fromMap(res.first);
  }
}
