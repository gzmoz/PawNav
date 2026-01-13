import 'package:flutter/material.dart';

class PetContextCard extends StatelessWidget {
  final String petName;
  final String? species;
  final String? breed;
  final String? imageUrl;
  final String statusLabel;

  const PetContextCard({
    super.key,
    required this.petName,
    required this.species,
    required this.breed,
    required this.imageUrl,
    required this.statusLabel,
  });

  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            color: Colors.black.withOpacity(0.06),
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Container(
              color: const Color(0xFFF3F4F6),
              width: width * 0.2,
              height: width * 0.2,
              child: imageUrl == null
                  ? const Icon(Icons.pets, size: 30, color: Color(0xFF9CA3AF))
                  : Image.network(imageUrl!, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PET DETAILS', style: TextStyle(color: const Color(0xFF6B7280), fontWeight: FontWeight.w800, fontSize: width * 0.034)),
                const SizedBox(height: 6),
                Text(petName, style: TextStyle(fontSize: width * 0.04, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(
                  [breed, species].where((e) => (e ?? '').trim().isNotEmpty).join(' • '),
                  style: TextStyle(color: const Color(0xFF6B7280), fontSize: width * 0.04),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFD1FAE5),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              statusLabel,
              style: TextStyle(color: Color(0xFF065F46), fontWeight: FontWeight.w900,fontSize: width * 0.03),
            ),
          ),
        ],
      ),
    );
  }
}
