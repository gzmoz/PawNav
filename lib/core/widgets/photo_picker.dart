import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoPicker extends StatelessWidget {
  final List<XFile> images;
  final VoidCallback onAdd;
  final Function(int index) onRemove;
  final int maxPhotos;

  const PhotoPicker({
    super.key,
    required this.images,
    required this.onAdd,
    required this.onRemove,
    this.maxPhotos = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 16, 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Photos",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
              ),
              Text(
                "Max $maxPhotos photos",
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          height: 92,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount:
            images.length < maxPhotos ? images.length + 1 : maxPhotos,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              if (index == images.length && images.length < maxPhotos) {
                return _addCard();
              }
              return _imageItem(images[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget _imageItem(XFile file, int index) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.file(
            File(file.path),
            width: 92,
            height: 92,
            fit: BoxFit.cover,
          ),
        ),

        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => onRemove(index),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 16,
                color: Colors.red,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _addCard() {
    return GestureDetector(
      onTap: onAdd,
      child: Container(
        width: 92,
        height: 92,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.grey.shade400,
            width: 1.2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_outlined,
                color: Colors.grey[500]),
            const SizedBox(height: 6),
            Text(
              "Add",
              style: TextStyle(
                color: Colors.grey[500],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
