import 'package:flutter/material.dart';
import 'package:pawnav/app/theme/colors.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background2,
      body: Center(
        child: Text("Addpost"),
      ),
    );
  }
}
