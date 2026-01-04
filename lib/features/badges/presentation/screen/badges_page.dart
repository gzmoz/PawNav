import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnav/features/badges/domain/logic/rank_calculator.dart';
import 'package:pawnav/features/badges/presentation/cubit/badge_cubit.dart';
import 'package:pawnav/features/badges/presentation/cubit/badge_state.dart';
import 'package:pawnav/features/badges/presentation/widget/badge_unlocked_modal.dart';
import '../widget/badges_header.dart';
import '../widget/badges_progress.dart';
import '../widget/badge_card.dart';

class BadgesPage extends StatefulWidget {
  const BadgesPage({super.key});

  @override
  State<BadgesPage> createState() => _BadgesPageState();
}

class _BadgesPageState extends State<BadgesPage> {
  @override
  void initState() {
    super.initState();
    context.read<BadgesCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7F7),
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Badges',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<BadgesCubit, BadgesState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(child: Text(state.error!));
          }
          final rank = RankCalculator.calculate(state.earnedCount);
          final overallProgress =
          state.totalCount == 0 ? 0.0 : (state.earnedCount / state.totalCount);


          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BadgesHeader(),
                  const SizedBox(height: 24),

                BadgesProgress(
                    earned: state.earnedCount,
                    total: state.totalCount,
                    progress: state.progress,
                    levelText: 'Level 3 Contributor', rank: rank, // şimdilik static
                  ),
                  const SizedBox(height: 22),

                  GridView.builder(
                    padding: const EdgeInsets.only(bottom: 8),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.68,
                    ),
                    itemCount: state.badges.length,
                    itemBuilder: (_, i) {
                      final badge = state.badges[i];
                      final earned = state.userBadgeIds.contains(badge.id);

                      return BadgeCard(
                        title: badge.name,
                        iconUrl: badge.iconUrl,
                        earned: earned,
                        onTap: () async {
                          await showModalBottomSheet(
                            context: context,
                            useRootNavigator: true,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            barrierColor: Colors.black.withOpacity(0.55),
                            builder: (sheetCtx) {
                              final isEarned = earned;

                              return BadgeUnlockedModal(
                                title: badge.name,
                                message: isEarned
                                    ? (badge.description ?? '')
                                    : "This badge is locked.\n${badge.description ?? ''}",
                                iconUrl: badge.iconUrl,
                                onContinue: () => Navigator.of(sheetCtx).pop(),
                                onViewBadges: () => Navigator.of(sheetCtx).pop(), earned: false,
                              );
                            },
                          );
                        },

                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
