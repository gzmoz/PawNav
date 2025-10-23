import 'package:flutter/material.dart';

class FeaturedPetCard extends StatelessWidget {
  final String petName;
  final String status;
  final String location;
  final String imageUrl;
  final VoidCallback? onTap;

  const FeaturedPetCard(
      {super.key,
      required this.petName,
      required this.location,
      required this.imageUrl,
      this.onTap, required this.status});

  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double width = screenInfo.size.width;
    final double height = screenInfo.size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width * 0.45,
        // height: height * 0.3,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.25),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: AspectRatio(
                aspectRatio: 1.5,
                child: Image.network(
                  imageUrl,
                  height: height * 0.15,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    petName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        status,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                      ),
                      Flexible(
                        child: Text(
                          " in $location",
                          overflow: TextOverflow.ellipsis, //  uzun olursa '...' koyar
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
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
