import 'package:flutter/material.dart';

class UserRank {
  final String title;
  final Color color;
  final IconData icon;
  final int level;
  final int minBadges;
  final int maxBadges;

  const UserRank({
    required this.title,
    required this.color,
    required this.icon,
    required this.level,
    required this.minBadges,
    required this.maxBadges,
  });
}
