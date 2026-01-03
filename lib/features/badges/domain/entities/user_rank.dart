import 'package:flutter/material.dart';

class UserRank {
  final String title;
  final Color color;
  final String iconAsset;
  final int level;
  final int minBadges;
  final int maxBadges;
  final List<Color> gradientColors;

  UserRank(
      {required this.title,
      required this.color,
      required this.iconAsset,
      required this.level,
      required this.minBadges,
      required this.maxBadges,
      required this.gradientColors});
}
