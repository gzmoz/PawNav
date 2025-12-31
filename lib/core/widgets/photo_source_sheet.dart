import 'package:flutter/material.dart';
import 'package:pawnav/core/utils/image_source_enum.dart';

class PhotoSourceSheet {
  static Future<ImageSourceType?> show(BuildContext context) {
    return showModalBottomSheet<ImageSourceType>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 20),

                  _item(
                    icon: Icons.photo_library_outlined,
                    title: "Gallery",
                    onTap: () =>
                        Navigator.pop(context, ImageSourceType.gallery),
                  ),

                  _item(
                    icon: Icons.camera_alt_outlined,
                    title: "Camera",
                    onTap: () =>
                        Navigator.pop(context, ImageSourceType.camera),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _item({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }
}
