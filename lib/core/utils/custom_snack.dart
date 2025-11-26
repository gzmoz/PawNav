import 'package:flutter/material.dart';
import 'package:pawnav/app/theme/colors.dart';

class AppSnackbar {
  static void show(
      BuildContext context,
      String message, {
        IconData icon = Icons.info_outline,
        Color color = const Color(0xFFF3F4F7),
        Duration duration = const Duration(seconds: 3),
      }) {
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
        margin: const EdgeInsets.all(16),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: color,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        duration: duration,
      ),
    );
  }

  // SUCCESS
  static void success(BuildContext context, String message) {
    show(
      context,
      message,
      icon: Icons.check_circle_outline,
      color: const Color(0xFF4CAF50),
    );
  }

  // ERROR
  static void error(BuildContext context, String message) {
    show(
      context,
      message,
      icon: Icons.error_outline,
      color: const Color(0xFFDE4F54), // soft red
    );
  }

  // INFO
  static void info(BuildContext context, String message) {
    show(
      context,
      message,
      icon: Icons.info_outline,
      color: AppColors.primary,
    );
  }

  // NEUTRAL
  static void neutral(BuildContext context, String message) {
    show(
      context,
      message,
      icon: Icons.info_outline,
      color: const Color(0xFFF3F4F7),
    );
  }
}
