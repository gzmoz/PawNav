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
        color: const Color(0xFFCD7474),
        iconAsset: 'assets/badges/shelter_hero.png',
        gradientColors: [
          const Color(0xFFDBAAAA),
          const Color(0xFFF9FAFB),
        ],
      );
    }

    if (badgeCount >= 6) {
      return UserRank(
        title: 'Guardian Angel',
        level: 3,
        minBadges: 6,
        maxBadges: 8,
        color: const Color(0xFF809E75),
        iconAsset: 'assets/badges/guardian_angel.png',
        gradientColors: [
          const Color(0xFFB8D7A3),
          const Color(0xFFF9FAFB),
        ],

      );
    }

    if (badgeCount >= 3) {
      return UserRank(
        title: 'Gold Helper',
        level: 2,
        minBadges: 3,
        maxBadges: 5,
        color: const Color(0xFF9D9B72),
        iconAsset: 'assets/badges/gold_helper.png',
        gradientColors: [
          const Color(0xFFE7DBAC),
          const Color(0xFFF9FAFB),
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
