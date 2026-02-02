import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnav/features/chat/data/models/message_model.dart';
import 'package:pawnav/features/chat/presentation/cubit/chat_detail_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatDetailCubit extends Cubit<ChatDetailState> {
  final String chatId;
  final supabase = Supabase.instance.client;

  RealtimeChannel? _channel;

  ChatDetailCubit(this.chatId) : super(const ChatDetailLoading()) {
    loadInitialMessages();
    subscribeRealtime();
  }

  @override
  Future<void> close() {
    if (_channel != null) {
      supabase.removeChannel(_channel!);
    }
    return super.close();
  }


  void subscribeRealtime() {
    _channel = supabase.channel('messages:$chatId');

    _channel!
        .onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'messages',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'chat_id',
        value: chatId,
      ),
      callback: (payload) {
        if (payload.newRecord == null) return;

        final newMessage =
        MessageModel.fromMap(payload.newRecord!);

        final currentState = state;
        if (currentState is ChatDetailLoaded) {
          // duplicate kontrolü
          final exists = currentState.messages
              .any((m) => m.id == newMessage.id);

          if (!exists) {
            emit(
              currentState.copyWith(
                messages: [
                  ...currentState.messages,
                  newMessage,
                ],
              ),
            );
          }
        }
      },
    )
        .subscribe();
  }


  Future<void> loadInitialMessages() async {
    try {
      final res = await supabase
          .from('messages')
          .select()
          .eq('chat_id', chatId)
          .order('created_at');

      final messages = (res as List)
          .map((e) => MessageModel.fromMap(e))
          .toList();

      emit(ChatDetailLoaded(messages: messages));
    } catch (e) {
      emit(ChatDetailError(e.toString()));
    }
  }


  Future<void> sendMessage(String text) async {
    try {
      final userId = supabase.auth.currentUser!.id;

      await supabase.from('messages').insert({
        'chat_id': chatId,
        'sender_id': userId,
        'text': text,
      });

      await supabase.from('chats').update({
        'last_message': text,
        'last_message_at': DateTime.now().toIso8601String(),
      }).eq('id', chatId);
    } catch (e) {
      emit(ChatDetailError(e.toString()));
    }
  }

}

