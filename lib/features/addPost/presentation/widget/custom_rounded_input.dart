import 'package:flutter/material.dart';
import 'package:pawnav/app/theme/colors.dart';

class CustomRoundedInput extends StatelessWidget {
  final Widget child;
  final IconData? leftIcon;
  final Widget? rightWidget;

  const CustomRoundedInput({
    super.key,
    required this.child,
    this.leftIcon, this.rightWidget,
  });

  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;
    return Container(
      height: height * 0.06,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          if (leftIcon != null)
            // Icon(leftIcon, color: Colors.grey[400], size: 22),
            Icon(leftIcon, color: AppColors.primary.withOpacity(0.9), size: 22),

          if (leftIcon != null) const SizedBox(width: 10),

          Expanded(child: child),

          // RIGHT WIDGET AREA
          if (rightWidget != null) ...[
            const SizedBox(width: 10),
            rightWidget!,
          ],
        ],
      ),
    );
  }
}
