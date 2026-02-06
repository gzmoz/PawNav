import 'package:flutter/material.dart';

class PostStatusStyle {
  static Color color(String? status) {
    switch (status) {
      case "Lost":
        return const Color(0xFFD9824F);
      case "Found":
        return const Color(0xFF6C8EBF);
      case "Adoption":
        return const Color(0xFF7FB77E);
      default:
        return Colors.grey;
    }
  }

  static Color background(String? status) {
    return color(status).withOpacity(0.95);
  }
}
