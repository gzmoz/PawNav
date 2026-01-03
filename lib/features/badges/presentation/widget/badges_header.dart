import 'package:flutter/material.dart';

class BadgesHeader extends StatelessWidget {
  const BadgesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your impact on the PawNav\ncommunity',
          style: TextStyle(
            fontSize: 30,
            height: 1.05,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
          ),
        ),
        SizedBox(height: 14),
        Text(
          'Collect badges by helping animals, donating, and\nengaging with the community.',
          style: TextStyle(
            fontSize: 16,
            height: 1.5,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }
}
