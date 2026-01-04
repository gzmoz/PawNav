import 'package:flutter/material.dart';
import 'package:pawnav/features/badges/domain/entities/user_rank.dart';

class BadgesProgress extends StatelessWidget {
  final int earned;
  final int total;
  final double progress;
  final String levelText;
  final UserRank rank;

  const BadgesProgress(
      {super.key,
      required this.earned,
      required this.total,
      required this.progress,
      required this.levelText,
      required this.rank});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Badges Earned',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE9EEFF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$earned / $total',
                style: const TextStyle(
                  color: Color(0xFF3B5BDB),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Text(
              'Level ${rank.level} • ${rank.title}',
              style: TextStyle(color: rank.color, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        /*Row(
          children: [
            Text(levelText, style: const TextStyle(color: Color(0xFF64748B))),
          ],
        ),*/
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            backgroundColor: const Color(0xFFE2E8F0),
            // color: const Color(0xFF3B5BDB),
            color: rank.color,
          ),
        ),
      ],
    );
  }
}
