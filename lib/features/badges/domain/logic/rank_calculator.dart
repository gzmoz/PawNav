import '../entities/user_rank.dart';
import 'package:flutter/material.dart';

class RankCalculator {
  static UserRank calculate(int badgeCount) {
    if (badgeCount >= 9) {
      return const UserRank(
        title: 'Shelter Hero',
        level: 4,
        minBadges: 9,
        maxBadges: 999,
        color: Colors.indigo,
        icon: Icons.shield,
      );
    }

    if (badgeCount >= 6) {
      return const UserRank(
        title: 'Guardian Angel',
        level: 3,
        minBadges: 6,
        maxBadges: 8,
        color: Colors.blue,
        icon: Icons.volunteer_activism,
      );
    }

    if (badgeCount >= 3) {
      return const UserRank(
        title: 'Gold Helper',
        level: 2,
        minBadges: 3,
        maxBadges: 5,
        color: Colors.amber,
        icon: Icons.workspace_premium,
      );
    }

    return const UserRank(
      title: 'New Helper',
      level: 1,
      minBadges: 0,
      maxBadges: 2,
      color: Colors.grey,
      icon: Icons.pets,
    );
  }
}
