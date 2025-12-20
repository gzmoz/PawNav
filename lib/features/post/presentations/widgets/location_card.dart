import 'package:flutter/material.dart';
import 'package:pawnav/app/theme/colors.dart';

class LocationCard extends StatelessWidget {
  final String title;
  final String address;

  const LocationCard({
    required this.title,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined, color: Colors.black54),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(
              address,
              style: const TextStyle(
                  color: Colors.black54, fontWeight: FontWeight.w600),
            ),
          ),

          // Map placeholder (şimdilik resim/boş container)
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(18)),
            child: Container(
              height: 180,
              color: Colors.grey.shade200,
              alignment: Alignment.center,
              child: const Text("MAP PREVIEW"),
            ),
          ),

          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.map_outlined),
            label: const Text("Open in Maps"),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}