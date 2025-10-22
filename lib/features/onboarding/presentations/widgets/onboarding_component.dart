import 'package:flutter/material.dart';

class OnboardingComponent extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  const OnboardingComponent({super.key, required this.title, required this.description, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.center,
            child: Image.asset(imagePath, height: height * 0.25)),
        SizedBox(height: height * 0.03),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.08),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: width * 0.06,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: height * 0.02),
        Padding(
          padding: EdgeInsets.symmetric(horizontal:  width * 0.08),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: width * 0.04,
              color: Colors.grey[7000],
              height: 1.4,
            ),
          ),
        ),

      ],
    );
  }
}
