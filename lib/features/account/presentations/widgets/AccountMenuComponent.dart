import 'package:flutter/material.dart';
import 'package:pawnav/app/theme/colors.dart';

import 'package:flutter/material.dart';
import 'package:pawnav/app/theme/colors.dart';

import 'package:flutter/material.dart';
import 'package:pawnav/app/theme/colors.dart';

class AccountMenuComponent extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const AccountMenuComponent({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final sizeInfo = MediaQuery.of(context);
    final double width = sizeInfo.size.width;

    final bool isClickable = onTap != null;

    return ListTile(
      leading: Container(
        width: width * 0.1,
        height: width * 0.1,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.lightBlue,
        ),
        child: Icon(
          icon,
          color: AppColors.primary,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: width * 0.04,
        ),
      ),

      //  Ok sadece tıklanabilirse
      trailing: isClickable
          ? const Icon(Icons.arrow_forward_ios, size: 16)
          : null,

      //  onTap null → tıklanamaz ama görünüm BOZULMAZ
      onTap: onTap,
    );
  }
}


// class AccountMenuComponent extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final VoidCallback? onTap;
//
//   const AccountMenuComponent(
//       {super.key, required this.icon, required this.title, this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     final sizeInfo = MediaQuery.of(context);
//     final double width = sizeInfo.size.width;
//     final double height = sizeInfo.size.height;
//     return ListTile(
//       leading: Container(
//         width: width * 0.1,
//         height: width * 0.1,
//         // margin: const EdgeInsets.only(top: 3),
//         decoration: const BoxDecoration(
//           shape: BoxShape.circle,
//           color: AppColors.lightBlue,
//         ),
//         child: Icon(
//           icon,
//           color: AppColors.primary,
//         ),
//       ),
//       title: Text(
//         title,
//         style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.04),
//       ),
//       trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//       onTap: onTap,
//     );
//   }
// }
