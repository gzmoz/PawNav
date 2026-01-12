import 'package:flutter/material.dart';

class PeopleRow extends StatelessWidget {
  final String roleLabel;
  final String name;
  final String? photoUrl;
  final Widget? trailing;
  final VoidCallback? onTap;

  const PeopleRow({
    super.key,
    required this.roleLabel,
    required this.name,
    required this.photoUrl,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final clickable = onTap != null;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE6E9EF)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xFFF3F4F6),
              backgroundImage: (photoUrl == null || photoUrl!.isEmpty) ? null : NetworkImage(photoUrl!),
              child: (photoUrl == null || photoUrl!.isEmpty)
                  ? const Icon(Icons.person, color: Color(0xFF9CA3AF))
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(roleLabel, style: const TextStyle(color: Color(0xFF6B7280), fontWeight: FontWeight.w900)),
                  const SizedBox(height: 2),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: clickable && name == 'Select user' ? const Color(0xFF6B7280) : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
