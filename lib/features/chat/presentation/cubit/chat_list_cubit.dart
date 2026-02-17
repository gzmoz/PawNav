import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnav/features/chat/data/repositories/chat_repository.dart';
import 'package:pawnav/features/chat/presentation/cubit/chat_list_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatListCubit extends Cubit<ChatListState> {
  final ChatRepository repo;
  final SupabaseClient supabase = Supabase.instance.client;

  RealtimeChannel? _channel;

  ChatListCubit(this.repo) : super(ChatListLoading()) {
    loadChats();
    _subscribeToChats();
  }

  void _subscribeToChats() {
    _channel = supabase.channel('chat-list');

    _channel!
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          callback: (payload) {
            print("MESSAGE INSERT EVENT RECEIVED");
            loadChats();
          },
        )
        .subscribe();
  }

  Future<void> loadChats() async {
    try {
      final chats = await repo.getChatList();
      emit(ChatListLoaded(chats));
    } catch (e) {
      emit(ChatListError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    if (_channel != null) {
      supabase.removeChannel(_channel!);
    }
    return super.close();
  }
}
