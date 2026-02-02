import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/features/chat/presentation/cubit/chat_detail_cubit.dart';
import 'package:pawnav/features/chat/presentation/cubit/chat_detail_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MessageList extends StatefulWidget {
  const MessageList({super.key});

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId =
        Supabase.instance.client.auth.currentUser!.id;

    return BlocBuilder<ChatDetailCubit, ChatDetailState>(
      builder: (context, state) {
        if (state is ChatDetailLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ChatDetailError) {
          return Center(child: Text(state.message));
        }

        if (state is! ChatDetailLoaded) {
          return const SizedBox.shrink();
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          itemCount: state.messages.length,
          itemBuilder: (context, index) {
            final msg = state.messages[index];
            final isMe = msg.senderId == currentUserId;

            if (msg.messageType == 'post' && msg.payload != null) {
              return _PostMessageBubble(
                payload: msg.payload!,
                isMe: isMe,
              );
            }

            return Align(
              alignment:
              isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                constraints: const BoxConstraints(maxWidth: 280),
                decoration: BoxDecoration(
                  color: isMe
                      ? const Color(0xFF2B6A94)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  msg.text ?? '',
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.black87,
                    fontSize: 15,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}


class _PostMessageBubble extends StatelessWidget {
  final Map<String, dynamic> payload;
  final bool isMe;

  const _PostMessageBubble({
    required this.payload,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(18),
      topRight: const Radius.circular(18),
      bottomLeft: Radius.circular(isMe ? 18 : 4),
      bottomRight: Radius.circular(isMe ? 4 : 18),
    );

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
          final postId = payload['post_id'];
          if (postId == null) return;

          context.push('/post-detail/$postId');
        },
        child: Container(
          width: 270,
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: borderRadius,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// IMAGE
              if (payload['image'] != null)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  child: Image.network(
                    payload['image'],
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// CHIP
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2B6A94).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "Post shared",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2B6A94),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// TITLE
                    Text(
                      payload['name'] ?? 'Post',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 4),

                    /// TYPE
                    Text(
                      payload['post_type'] ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// CTA (visual only – tap handled by GestureDetector)
                    const Row(
                      children: [
                        Icon(
                          Icons.open_in_new,
                          size: 14,
                          color: Color(0xFF2B6A94),
                        ),
                        SizedBox(width: 4),
                        Text(
                          "View post",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2B6A94),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




