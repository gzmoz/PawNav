import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnav/features/chat/presentation/cubit/chat_detail_cubit.dart';
import 'package:pawnav/features/chat/presentation/cubit/chat_detail_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MessageList extends StatelessWidget {
  const MessageList({super.key});

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

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          itemCount: state.messages.length,
          itemBuilder: (context, index) {
            final msg = state.messages[index];
            final isMe = msg.senderId == currentUserId;

            return Align(
              alignment:
              isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                constraints: const BoxConstraints(maxWidth: 280),
                decoration: BoxDecoration(
                  color: isMe
                      ? const Color(0xFF2B6A94) // sen
                      : Colors.white, // karşı taraf
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  msg.text,
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
