import 'package:flutter/material.dart';

class GenderSelector extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const GenderSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  static const _options = ["Male", "Female", "Unknown"];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: _options.map((option) {
          final bool selected = option == value;

          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(option),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF2563EB)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 250),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: selected
                          ? Colors.white
                          : Colors.grey.shade600,
                    ),
                    child: Text(option),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

