import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationCard extends StatelessWidget {
  final String title;
  final String address;

  const LocationCard({
    required this.title,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;

    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];

    final staticMapUrl =
        "https://maps.googleapis.com/maps/api/staticmap"
        "?center=${Uri.encodeComponent(address)}"
        "&zoom=14"
        "&size=600x300"
        "&markers=color:red|${Uri.encodeComponent(address)}"
        "&key=$apiKey";

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
                    style: TextStyle(
                      fontSize: width * 0.043,
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
              style: TextStyle(
                color: Colors.black54, fontWeight: FontWeight.w600,
                fontSize: width * 0.03,


              ),
            ),
          ),

          // Map placeholder (şimdilik resim/boş container)
          /*ClipRRect(
            borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(18)),
            child: Container(
              height: 180,
              color: Colors.grey.shade200,
              alignment: Alignment.center,
              child: const Text("MAP PREVIEW"),
            ),
          ),*/
          /// STATIC MAP PREVIEW
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(18),
            ),
            child: Image.network(
              staticMapUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  height: 180,
                  color: Colors.grey.shade200,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                );
              },
              errorBuilder: (_, __, ___) => Container(
                height: 180,
                color: Colors.grey.shade300,
                alignment: Alignment.center,
                child: const Text("Map unavailable"),
              ),
            ),
          ),


          TextButton.icon(
            onPressed: () async {
              final uri = Uri.parse(
                "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}",
              );

              if (await canLaunchUrl(uri)) {
                await launchUrl(
                  uri,
                  mode: LaunchMode.externalApplication,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Could not open Maps")),
                );
              }
            },

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