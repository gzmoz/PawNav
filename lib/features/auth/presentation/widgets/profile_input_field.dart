import 'package:flutter/material.dart';

class ProfileInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscure;

  const ProfileInputField({
    super.key,
    required this.hintText,
    required this.controller,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: height *0.06,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1.2,
        ),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: Colors.grey.shade500,
              fontSize: height *0.015,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
