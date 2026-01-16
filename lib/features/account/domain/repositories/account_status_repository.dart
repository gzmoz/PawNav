import 'package:pawnav/features/account/data/models/account_status_model.dart';

abstract class AccountStatsRepository {
  Future<AccountStats> getStats();
}
