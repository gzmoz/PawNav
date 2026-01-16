import 'package:flutter/material.dart';
import '../../data/models/success_story_model.dart';

class SuccessStoryGridCard extends StatelessWidget {
  final String imageUrl;
  final String petName;
  final String subtitle;
  final bool isAdopted;
  final VoidCallback onTap;

  const SuccessStoryGridCard({
    super.key,
    required this.imageUrl,
    required this.petName,
    required this.subtitle,
    required this.isAdopted,
    required this.onTap,
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.pets, size: 40),
                      ),
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: Colors.grey.shade100,
                          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        );
                      },
                    ),

                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: _StatusBadge(isAdopted: isAdopted),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    petName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 30,
                    child: Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        height: 1.2,
                      ),
                    ),
                  ),

                  /*Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isAdopted;

  const _StatusBadge({required this.isAdopted});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isAdopted ? Colors.blue : Colors.green,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isAdopted ? "ADOPTED" : "REUNITED",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
