import 'package:flutter/material.dart';

class ButtonComponent extends StatelessWidget {
  String buttonText;
  Color textColor;
  Color buttonColor;
  VoidCallback callback;
  Widget? prefix;
  Widget? suffix;
  final double? width;
  final double? height;

  ButtonComponent(
    this.buttonText,
    this.textColor,
    this.buttonColor,
    this.callback, {
    this.prefix,
    this.suffix,
    this.width,
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double screenHeight = screenInfo.size.height;
    final double screenWidth = screenInfo.size.width;

    return GestureDetector(
      onTap: callback,
      child: Container(
        width: width ?? screenWidth * 0.45,
        height: height ?? screenHeight * 0.05,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(80),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 2,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (prefix != null)
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: prefix!,
                  ),
                  SizedBox(width: screenWidth * 0.015),
                ],
              ),

            // Ortadaki metin
            Text(
              buttonText,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: textColor,
              ),
            ),

            // Eğer suffix varsa, sonra suffix'i ekle
            if (suffix != null)
              Row(
                children: [
                  SizedBox(width: screenWidth * 0.015),
                  suffix!,
                ],
              ),
          ],
        ),
      ),
    );
  }
}
