import 'package:flutter/material.dart';

/// Ana renk (ikon rengi için)
Color getPetColor(String? color) {
  switch (color?.toLowerCase()) {
    case "black":
      return Colors.black;
    case "white":
      return Colors.grey.shade300;
    case "brown":
      return Colors.brown;
    case "golden / cream":
      return const Color(0xFFFFD966);
    case "gray":
      return Colors.grey;
    case "orange":
      return Colors.orange;
    case "calico":
      return Colors.orangeAccent;
    case "tabby":
      return Colors.brown.shade400;
    case "mixed":
      return Colors.blueGrey;
    case "unknown":
      return Colors.grey.shade500;
    default:
      return Colors.grey;
  }
}

/// Arka plan rengi (ikonBg için)
Color getPetColorBg(String? color) {
  return getPetColor(color).withOpacity(0.15);
}
