import 'package:pawnav/features/chat/data/models/chat_preview_model.dart';

abstract class ChatListState {}

class ChatListLoading extends ChatListState {}

class ChatListLoaded extends ChatListState {
  final List<ChatPreviewModel> chats;
  ChatListLoaded(this.chats);
}

class ChatListError extends ChatListState {
  final String message;
  ChatListError(this.message);
}
