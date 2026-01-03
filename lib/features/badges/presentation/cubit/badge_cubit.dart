import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnav/features/badges/domain/logic/rank_calculator.dart';
import 'package:pawnav/features/badges/domain/usecases/get_user_badges.dart';
import 'package:pawnav/features/badges/presentation/cubit/badge_state.dart';
import '../../domain/usecases/get_all_badges.dart';

class BadgesCubit extends Cubit<BadgesState> {
  final GetAllBadges getAllBadges;
  final GetUserBadgeIds getUserBadgeIds;


  BadgesCubit({
    required this.getAllBadges,
    required this.getUserBadgeIds,
  }) : super(BadgesState.initial());

  Future<void> load() async {
    try {
      emit(BadgesState.initial());

      final badges = await getAllBadges();
      final userIds = await getUserBadgeIds();

      emit(BadgesState(
        isLoading: false,
        badges: badges,
        userBadgeIds: userIds,
      ));
    } catch (e) {
      emit(BadgesState(isLoading: false, badges: [], userBadgeIds: {}, error: e.toString()));
    }
  }
}
