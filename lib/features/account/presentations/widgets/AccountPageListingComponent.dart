import 'package:flutter/material.dart';
import 'package:pawnav/app/theme/colors.dart';

class AccountPageListingComponent extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;


  const AccountPageListingComponent({super.key, required this.icon, required this.title, required this.subtitle, this.onTap});

  @override
  Widget build(BuildContext context) {
    final sizeInfo = MediaQuery.of(context);
    final double width = sizeInfo.size.width;
    final double height = sizeInfo.size.height;
    return ListTile(
      leading: Icon(icon, color: AppColors.primary,),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.04),),
      subtitle: Text(subtitle,style: TextStyle(fontSize: width * 0.035)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
