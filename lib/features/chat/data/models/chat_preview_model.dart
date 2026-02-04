class ChatPreviewModel {
  final String chatId;
  final String name;
  final String avatarUrl;
  final String lastMessage;
  final DateTime lastMessageAt;

  ChatPreviewModel({
    required this.chatId,
    required this.name,
    required this.avatarUrl,
    required this.lastMessage,
    required this.lastMessageAt,
  });
}