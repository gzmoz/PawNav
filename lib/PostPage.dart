import 'package:flutter/material.dart';
import 'package:pawnav/app/theme/colors.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background2,
      body: Center(
        child: Text("Post"),
      ),
    );
  }
}
