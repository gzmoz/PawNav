import 'dart:io';
import 'package:flutter/material.dart';

class EditProfileAvatarEditor extends StatelessWidget {
  final String? photoUrl;
  final VoidCallback onEdit;

  const EditProfileAvatarEditor({
    super.key,
    required this.photoUrl,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final ImageProvider? imageProvider = _resolveImage();

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: imageProvider,
          child: imageProvider == null
              ? const Icon(Icons.person, size: 50, color: Colors.grey)
              : null,
        ),

        /// EDIT BUTTON
        GestureDetector(
          onTap: onEdit,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF233E96), Color(0xFF3C59C7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: const Icon(
              Icons.edit,
              size: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  ImageProvider? _resolveImage() {
    if (photoUrl == null || photoUrl!.isEmpty) return null;

    if (photoUrl!.startsWith('http')) {
      return NetworkImage(photoUrl!);
    }

    return FileImage(File(photoUrl!));
  }
}
