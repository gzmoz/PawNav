class MessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String messageType;
  final String? text;
  final Map<String, dynamic>? payload;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.messageType,
    this.text,
    this.payload,
    required this.createdAt,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'],
      chatId: map['chat_id'],
      senderId: map['sender_id'],
      messageType: map['message_type'],
      text: map['text'],
      payload: map['payload'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}

