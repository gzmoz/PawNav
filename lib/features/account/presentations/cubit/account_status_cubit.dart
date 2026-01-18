import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnav/features/account/data/models/account_status_model.dart';
import 'package:pawnav/features/account/domain/repositories/account_status_repository.dart';

class AccountStatsCubit extends Cubit<AccountStats?> {
  final AccountStatsRepository repository;

  AccountStatsCubit(this.repository) : super(null);

  Future<void> loadStats() async {
    try {
      final stats = await repository.getStats();
      emit(stats);
    } catch (e) {
      debugPrint('AccountStats error: $e');
    }
  }

  Future<void> refresh() async {
    await loadStats();
  }
}

