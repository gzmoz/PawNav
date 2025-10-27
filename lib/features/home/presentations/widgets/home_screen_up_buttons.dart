import 'package:flutter/material.dart';
import 'package:pawnav/app/theme/colors.dart';

class HomeButtonComponent extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const HomeButtonComponent(
      {super.key,
      required this.icon,
      required this.title,
      required this.subtitle,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final sizeInfo = MediaQuery.of(context);
    final double width = sizeInfo.size.width;
    final double height = sizeInfo.size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width * 0.3,
        // height: height * 0.19,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: AppColors.white2,
          // color: Colors.white,
          // color: AppColors.primary.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 4,
              blurRadius: 8,
              offset: const Offset(2,2),
            ),

          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: height * 0.05,
            ),
            SizedBox(
              height: height * 0.003,
            ),
            Text(
              title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: height * 0.003),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: width * 0.03,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: height * 0.01),
          ],
        ),
      ),
    );
  }
}
