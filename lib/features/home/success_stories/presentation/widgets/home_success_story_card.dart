import 'package:flutter/material.dart';

// class HomeSuccessStoryCard extends StatelessWidget {
//   final String imageUrl;
//   final String title;
//   final String description;
//
//   const HomeSuccessStoryCard({
//     super.key,
//     required this.imageUrl,
//     required this.title,
//     required this.description,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final h = MediaQuery.of(context).size.height;
//     final w = MediaQuery.of(context).size.width;
//
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(12),
//       child: Stack(
//         children: [
//           Image.network(
//             imageUrl,
//             fit: BoxFit.cover,
//             width: double.infinity,
//             height: h * 0.25,
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               height: h * 0.08,
//               padding: const EdgeInsets.all(12),
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [Colors.transparent, Colors.black],
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(title,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: w * 0.045,
//                           fontWeight: FontWeight.bold)),
//                   Text(description,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                           color: Colors.white70,
//                           fontSize: w * 0.03)),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class HomeSuccessStoryCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final VoidCallback? onTap;

  const HomeSuccessStoryCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            /// IMAGE (Supabase → network)
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: height * 0.25,
              errorBuilder: (_, __, ___) => Container(
                height: height * 0.25,
                color: Colors.grey.shade300,
                child: const Icon(Icons.pets, size: 40),
              ),
            ),

            /// GRADIENT + TEXT
            Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: 0.3,
                widthFactor: 1.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(1),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.05,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.03,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

