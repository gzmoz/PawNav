import 'package:flutter/material.dart';

class BadgeCard extends StatelessWidget {
  final String title;
  final String iconUrl;
  final bool earned;
  final VoidCallback onTap;

  const BadgeCard({
    super.key,
    required this.title,
    required this.iconUrl,
    required this.earned,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor =
    earned ? const Color(0xFF0F172A) : const Color(0xFF94A3B8);

    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: earned ? 1 : 0.35,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // LOCK ICON
              Align(
                alignment: Alignment.topRight,
                child: !earned
                    ? const Icon(Icons.lock,
                    size: 16, color: Color(0xFF94A3B8))
                    : const SizedBox(height: 16),
              ),

              // ICON
              Container(
                height: 52,
                width: 52,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF1F5F9),
                ),
                child: Expanded(
                  child: Image.network(iconUrl, fit: BoxFit.contain),
                ),
              ),

              // TITLE
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),

              // STATUS
              Text(
                earned ? 'EARNED' : 'LOCKED',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: earned
                      ? const Color(0xFF16A34A)
                      : const Color(0xFFCBD5E1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
