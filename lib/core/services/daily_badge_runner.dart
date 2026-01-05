import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pawnav/features/badges/presentation/widget/badge_unlocked_modal.dart';

class DailyBadgeRunner {
  static bool _didRunThisSession = false;

  static Future<void> run(BuildContext context) async {
    if (_didRunThisSession) return;
    _didRunThisSession = true;

    final supabase = Supabase.instance.client;
    final uid = supabase.auth.currentUser?.id;
    if (uid == null) return;

    try {
      // 1) bugün activity kaydet (DB tarafı aynı gün 2 kere saymamalı)
      await supabase.rpc('record_daily_activity');

      // 2) user_stats çek
      final stats = await supabase
          .from('user_stats')
          .select('streak_days, active_days')
          .eq('user_id', uid)
          .maybeSingle();

      final streakDays = (stats?['streak_days'] as int?) ?? 0;
      final activeDays = (stats?['active_days'] as int?) ?? 0;

      // 3) unlock listesi (aynı gün iki badge birden gelirse sırayla gösterir)
      final List<String> badgeKeysToUnlock = [];
      if (streakDays >= 7) badgeKeysToUnlock.add('daily_helper');
      if (activeDays >= 14) badgeKeysToUnlock.add('guardian_angel');

      // hiç badge yoksa çık
      if (badgeKeysToUnlock.isEmpty) return;

      // 4) Her badge için: zaten earned mı? değilse insert + modal
      for (final key in badgeKeysToUnlock) {
        if (!context.mounted) return;

        final unlockedNow = await _unlockIfNotEarned(supabase, uid, key);
        if (!unlockedNow) continue;

        final badgeRow = await supabase
            .from('badges')
            .select('name, description, icon_url')
            .eq('key', key)
            .maybeSingle();

        if (badgeRow == null) continue;

        final name = badgeRow['name'] as String? ?? 'Badge';
        final desc = badgeRow['description'] as String? ?? '';
        final iconUrl = badgeRow['icon_url'] as String? ?? '';

        if (iconUrl.isEmpty) continue;

        await showModalBottomSheet(
          context: context,
          useRootNavigator: true,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          barrierColor: Colors.black.withOpacity(0.55),
          builder: (sheetCtx) => BadgeUnlockedModal(
            title: name,
            message: desc,
            iconUrl: iconUrl,
            onContinue: () => Navigator.of(sheetCtx).pop(),
            onViewBadges: () {
              Navigator.of(sheetCtx).pop();
              // push kullan: geri dönebilsin
              context.push('/badges');
            },
            earned: true,
          ),
        );
      }
    } catch (e) {
      debugPrint("DailyBadgeRunner error: $e");
      // sessiz geçiyoruz: app akışı bozulmasın
    }
  }

  static Future<bool> _unlockIfNotEarned(
      SupabaseClient supabase,
      String uid,
      String badgeKey,
      ) async {
    // badge id
    final badge = await supabase
        .from('badges')
        .select('id')
        .eq('key', badgeKey)
        .maybeSingle();

    final badgeId = badge?['id'] as String?;
    if (badgeId == null) return false;

    // user zaten almış mı?
    final existing = await supabase
        .from('user_badges')
        .select('id')
        .eq('user_id', uid)
        .eq('badge_id', badgeId)
        .maybeSingle();

    if (existing != null) return false;

    // insert
    await supabase.from('user_badges').insert({
      'user_id': uid,
      'badge_id': badgeId,
    });

    return true; // şimdi unlock oldu -> modal göster
  }
}
