import 'package:pawnav/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:pawnav/features/chat/data/models/chat_preview_model.dart';

class ChatRepository {
  final ChatRemoteDataSource remote;

  ChatRepository(this.remote);

  Future<List<ChatPreviewModel>> getChatList() async {
    final data = await remote.getChats();

    return data.map((e) {
      return ChatPreviewModel(
        chatId: e['chat_id'],
        name: e['other_user_name'],
        avatarUrl: e['other_user_photo'] ?? '',
        lastMessage: e['last_message'] ?? '',
        lastMessageAt: DateTime.parse(e['last_message_at']),
      );
    }).toList();
  }
}
