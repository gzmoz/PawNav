import 'package:flutter/material.dart';
import 'package:pawnav/features/badges/domain/entities/user_rank.dart';

class UserRankCard extends StatelessWidget {
  final VoidCallback? onTap;
  final UserRank rank;

  const UserRankCard({super.key, this.onTap, required this.rank});



  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: rank.gradientColors,
            ),
            borderRadius: BorderRadius.circular(40),
          ),

          /*decoration: BoxDecoration(
            color: rank.color.withOpacity(0.3),
            borderRadius: BorderRadius.circular(30),

          ),*/
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              //Icon(rankIcon, color: Colors.black, size: width * 0.05),
              Container(
                width: width * 0.07,
                height: width * 0.07,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.9),
                ),
                child: Image.asset(
                  rank.iconAsset,
                  fit: BoxFit.contain,

                ),
              ),

              /* Image.asset(
                rank.iconAsset,
                width: 22,
                height: 22,
              ),*/
              const SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rank.title,
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
        ),
      ),
    );
  }
}
