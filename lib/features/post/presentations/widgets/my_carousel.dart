import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pawnav/app/theme/colors.dart';

class MyCarousel extends StatefulWidget {
  final List<String> images;
  final String statusText;
  final Color statusColor;
  final Color statusBg;

  const MyCarousel(
      {super.key,
      required this.images,
      required this.statusText,
      required this.statusColor,
      required this.statusBg});

  //“Ben, üst sınıfta (StatefulWidget) zaten var olan bir metodu ezip kendi versiyonumu yazıyorum”
  @override
  State<MyCarousel> createState() => _MyCarouselState();
}

class _MyCarouselState extends State<MyCarousel> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Stack(
        children: [
          SizedBox(
            height: 280,
            child: PageView.builder(
              itemCount: widget.images.length,
              onPageChanged: (int i) {
                setState(() {
                  index = i;
                });
              },
              /*
                * _ kullanmak Dart’ta şu anlama gelir:
                “Bu parametre geliyor ama umurumda değil”*/
              itemBuilder: (_, i) => Image.network(
                widget.images[i],
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),

          //status chip
          Positioned(
            top: 14,
            left: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: widget.statusColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    widget.statusText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
            ),
          ),

          //dots
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.images.length, (i) {
                final active = i == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: active ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: active ? AppColors.primary : Colors.white70,
                    borderRadius: BorderRadius.circular(6),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
