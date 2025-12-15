import 'package:flutter/material.dart';
import 'package:pawnav/app/theme/colors.dart';

class PostStatusStyle {
  static Color color(String? status) {
    switch (status) {
      case "Lost":
        return Colors.red.shade300;
      case "Found":
        return AppColors.primary.withOpacity(0.4);
      case "Adoption":
        return Colors.green.shade400;
      default:
        return Colors.grey;
    }
  }

  static Color background(String? status) {
    return color(status).withOpacity(0.85);
  }
}
