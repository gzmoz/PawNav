import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditPhotoPicker extends StatelessWidget {
  // Backend’den gelen mevcut fotoğraflar (URL)
  final List<String> networkImages;

  //Edit sırasında eklenen yeni fotoğraflar
  final List<XFile> localImages;

  final VoidCallback onAdd;

  //(local) foto silme
  final Function(int index) onRemoveLocal;

  //  Mevcut (network) foto silme
  final Function(int index) onRemoveNetwork;

  final int maxPhotos;

  const EditPhotoPicker({
    super.key,
    required this.networkImages,
    required this.localImages,
    required this.onAdd,
    required this.onRemoveLocal,
    required this.onRemoveNetwork,
    this.maxPhotos = 5,
  });

  @override
  Widget build(BuildContext context) {
    final totalCount = networkImages.length + localImages.length;

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
            totalCount < maxPhotos ? totalCount + 1 : maxPhotos,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              // Add card
              if (index == totalCount && totalCount < maxPhotos) {
                return _addCard();
              }

              // Önce NETWORK images
              if (index < networkImages.length) {
                return _networkImageItem(
                  networkImages[index],
                  index,
                );
              }

              // Sonra LOCAL images
              final localIndex = index - networkImages.length;
              return _localImageItem(
                localImages[localIndex],
                localIndex,
              );
            },
          ),
        ),
      ],
    );
  }

  // Backend’den gelen foto
  Widget _networkImageItem(String url, int index) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.network(
            url,
            width: 92,
            height: 92,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => onRemoveNetwork(index),
            child: _closeButton(),
          ),
        ),
      ],
    );
  }

  //Yeni eklenen foto
  Widget _localImageItem(XFile file, int index) {
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
            onTap: () => onRemoveLocal(index),
            child: _closeButton(),
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
            Icon(Icons.camera_alt_outlined, color: Colors.grey[500]),
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

  Widget _closeButton() {
    return Container(
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
    );
  }
}
