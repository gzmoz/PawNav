import 'package:flutter/material.dart';

class UserRankCard extends StatelessWidget {
  final String rankTitle; // "Gold Helper"
  final IconData rankIcon; // Icons.star
  final Color rankColor; // Colors.amber
  const UserRankCard(
      {super.key,
      required this.rankTitle,
      required this.rankIcon,
      required this.rankColor});

  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: rankColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(30),
        /*boxShadow: [
          BoxShadow(
            color: rankColor.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],*/
        /*border: Border.all(
          color: rankColor.withOpacity(0.6),
          width: 1.2,
        ),*/
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(rankIcon, color: Colors.black, size: width * 0.05),
          const SizedBox(width: 2),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                rankTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: width * 0.03,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
