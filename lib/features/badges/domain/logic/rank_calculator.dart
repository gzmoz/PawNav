import '../entities/user_rank.dart';
import 'package:flutter/material.dart';

class RankCalculator {
  static UserRank calculate(int badgeCount) {
    if (badgeCount >= 9) {
      return UserRank(
        title: 'Shelter Hero',
        level: 4,
        minBadges: 9,
        maxBadges: 999,
        color: const Color(0xFF8B3A3A),
        iconAsset: 'assets/badges/shelter_hero.png',
        gradientColors: [
          const Color(0xFFF3E1E1),
          const Color(0xFFD8A5A5),
        ],
      );
    }

    if (badgeCount >= 6) {
      return UserRank(
        title: 'Guardian Angel',
        level: 3,
        minBadges: 6,
        maxBadges: 8,
        color: const Color(0xFF4F7F6A),
        iconAsset: 'assets/badges/guardian_angel.png',
        gradientColors: [
          const Color(0xFFE6F1EB),
          const Color(0xFFB7D3C6),
        ],
      );
    }

    if (badgeCount >= 3) {
      return UserRank(
        title: 'Gold Helper',
        level: 2,
        minBadges: 3,
        maxBadges: 5,
        color: const Color(0xFFC9A227),
        iconAsset: 'assets/badges/gold_helper.png',
        gradientColors: [
          const Color(0xFFF7F1D7),
          const Color(0xFFE6C75F),
        ],
      );
    }

    return UserRank(
      title: 'New Helper',
      level: 1,
      minBadges: 0,
      maxBadges: 2,
      color: Colors.grey,
      iconAsset: 'assets/badges/new_helper.png',
      gradientColors: [
        const Color(0xFFD4D5D9),
        const Color(0xFFF9FAFB),
      ],
    );
  }
}
