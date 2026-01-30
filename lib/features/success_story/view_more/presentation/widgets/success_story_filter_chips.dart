import 'package:flutter/material.dart';
import '../../domain/success_story_filter.dart';

class SuccessStoryFilterChips extends StatelessWidget {
  final SuccessStoryFilter selected;
  final ValueChanged<SuccessStoryFilter> onChanged;

  const SuccessStoryFilterChips({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    Widget chip({
      required String label,
      required IconData icon,
      required SuccessStoryFilter value,
    }) {
      final isSelected = selected == value;
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ]
              : [],
        ),
        child: ChoiceChip(
          showCheckmark: false,
          side: BorderSide.none,
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : Colors.black54,
              ),
              const SizedBox(width: 6),
              Text(label),
            ],
          ),
          selected: isSelected,
          onSelected: (_) => onChanged(value),
          selectedColor: const Color(0xFF2B6A94),
          backgroundColor: Colors.white,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black54,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          chip(
            label: 'All Stories',
            icon: Icons.apps,
            value: SuccessStoryFilter.all,
          ),
          const SizedBox(width: 10),
          chip(
            label: 'Reunited',
            icon: Icons.favorite,
            value: SuccessStoryFilter.reunited,
          ),
          const SizedBox(width: 10),
          chip(
            label: 'Adopted',
            icon: Icons.home,
            value: SuccessStoryFilter.adopted,
          ),
        ],
      ),
    );
  }

}
