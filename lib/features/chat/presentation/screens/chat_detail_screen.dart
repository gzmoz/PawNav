import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/features/chat/presentation/widgets/message_input.dart';
import 'package:pawnav/features/chat/presentation/widgets/message_list.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatDetailScreen extends StatelessWidget {
  final String chatId;
  const ChatDetailScreen({super.key, required this.chatId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      appBar: _ChatAppBar(chatId: chatId),
      body: const Column(
        children: [
          SizedBox(height: 8),

          /// CONTEXT INFO (This chat is about the post…)
          /*Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline,
                      size: 18, color: AppColors.primary),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      "This chat is about the post: Lost Golden Retriever",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),*/

          SizedBox(height: 8),

          /// MESSAGE LIST
          Expanded(
            child: MessageList(),
          ),

          /// INPUT
          MessageInput(),
        ],
      ),
    );
  }

}

class _ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String chatId;
  const _ChatAppBar({required this.chatId});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final currentUserId = supabase.auth.currentUser!.id;

    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchOtherUser(supabase, chatId, currentUserId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return AppBar(
            backgroundColor: AppColors.lightBlue,
            elevation: 0.6,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              onPressed: () => context.pop(),
            ),
            title: const Text("Chat"),
          );
        }

        final user = snapshot.data!;

        return AppBar(
          backgroundColor: const Color(0xFF2B6A94).withOpacity(0.15),
          elevation: 0.6,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => context.pop(),
          ),
          titleSpacing: 0,
          title: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: user['photo_url'] != null
                    ? NetworkImage(user['photo_url'])
                    : null,
                child: user['photo_url'] == null
                    ? const Icon(Icons.person, size: 18)
                    : null,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user['name'] ?? user['username'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  /*const Text(
                    "Regarding: Lost Golden Retriever", // sonra dinamik bağlarız
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),*/
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert_rounded),
              onPressed: () {},
            ),
          ],
        );
      },
    );
  }


  Future<Map<String, dynamic>> _fetchOtherUser(
      SupabaseClient supabase,
      String chatId,
      String currentUserId,
      ) async {
    final chat = await supabase
        .from('chats')
        .select('a_id, b_id')
        .eq('id', chatId)
        .single();

    final otherUserId =
    chat['a_id'] == currentUserId ? chat['b_id'] : chat['a_id'];

    final profile = await supabase
        .from('profiles')
        .select('name, username, photo_url')
        .eq('id', otherUserId)
        .single();

    return profile;
  }
}

