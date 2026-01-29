import 'package:flutter/material.dart';
import 'package:pawnav/core/utils/time_ago.dart';
import 'package:pawnav/features/success_story/domain/repositories/post_type_enum.dart';
import '../../data/success_story_list_item_model.dart';

class SuccessStoryListCard extends StatelessWidget {
  final SuccessStoryListItemModel item;
  final VoidCallback onTap;

  const SuccessStoryListCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  String get badgeLabel {
    return item.postType == PostType.adopted ? 'ADOPTED' : 'REUNITED';
  }

  Color get badgeColor {
    return item.postType == PostType.adopted
        ? const Color(0xFF358C5A).withOpacity(0.8)
        :  const Color(0xFF3A65C2).withOpacity(0.8);
  }

  String get topCategory {
    return item.postType == PostType.adopted ? 'FOREVER HOME' : 'COMMUNITY WIN';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 18,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: item.imageUrl.isEmpty
                        ? Container(color: const Color(0xFFEFEFF4))
                        : Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        badgeLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // BODY
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topCategory,
                    style: const TextStyle(
                      color: Color(0xFF2B6A94),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.35,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Colors.black45),
                      const SizedBox(width: 6),
                      Text(
                        timeAgo(item.createdAt),
                        style: const TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF0FF),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Text(
                          'Read Story',
                          style: TextStyle(
                            color: Color(0xFF2B6A94),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
