import 'package:flutter/material.dart';
import 'package:pawnav/app/theme/colors.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background2,
      body: Center(
        child: Text("Message"),
      ),
    );
  }
}
