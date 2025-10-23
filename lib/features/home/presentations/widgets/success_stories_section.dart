import 'package:flutter/material.dart';

class SuccessStoriesCustom extends StatelessWidget {
  final String? imagePath;
  final String? title;
  final String? description;
  final VoidCallback? onTap;

  const SuccessStoriesCustom(
      {super.key, this.imagePath, this.onTap, this.title, this.description});

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
            Image.asset(
              imagePath!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: height * 0.25,
            ),
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
                        ]),
                  ),
                  child: Column(
                    children: [
                      Text(title!,overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: width * 0.05),),
                      Text(description!,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: width * 0.03),),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    /*Image.asset(
      imagePath!,
      fit: BoxFit.cover,

    );*/
  }
}
