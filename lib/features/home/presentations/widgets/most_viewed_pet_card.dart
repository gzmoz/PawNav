import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/core/utils/post_status.dart';
import 'package:pawnav/features/post/domain/entities/post.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/core/utils/time_ago.dart';

class MostViewedPetCard extends StatelessWidget {
  final Post post;

  const MostViewedPetCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/post-detail/${post.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
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
            _imageSection(),
            _contentSection(),
          ],
        ),
      ),
    );
  }

  // ---------------- IMAGE ----------------

  Widget _imageSection() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Image.network(
            post.images!.first,
            height: 220,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),

        Positioned(top: 12, left: 12, child: _statusChip()),
        Positioned(bottom: 12, right: 12, child: _viewsChip()),
      ],
    );
  }

  Widget _statusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: PostStatusStyle.color(post.postType),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_statusIcon(), size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            post.postType!.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _viewsChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.remove_red_eye, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            _formatViews(post.views),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // ---------------- CONTENT ----------------

  Widget _contentSection() {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name
          Text(
            post.name ?? 'Unknown',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          // Breed · Gender
          Text(
            "${post.breed ?? 'Unknown'} • ${post.gender ?? 'Unknown'}",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 8),

          // Location
          Row(
            children: [
              const Icon(Icons.location_on,
                  size: 16, color: AppColors.primary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  post.location,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Posted ${timeAgo(post.eventDate)}",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
              const Text(
                "View Details",
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- HELPERS ----------------

  IconData _statusIcon() {
    switch (post.postType) {
      case 'Lost':
        return Icons.warning_amber_rounded;
      case 'Found':
        return Icons.check_circle;
      case 'Adoption':
        return Icons.favorite;
      default:
        return Icons.info;
    }
  }

  String _formatViews(int views) {
    if (views >= 1000) {
      return "${(views / 1000).toStringAsFixed(1)}k";
    }
    return views.toString();
  }
}
