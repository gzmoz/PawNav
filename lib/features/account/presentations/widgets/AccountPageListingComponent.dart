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
    return ListTile(
      leading: Icon(icon, color: AppColors.primary,),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold),),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
