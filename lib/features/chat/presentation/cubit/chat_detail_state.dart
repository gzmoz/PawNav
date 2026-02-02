import '../../data/models/message_model.dart';

abstract class ChatDetailState {
  const ChatDetailState();
}

class ChatDetailLoading extends ChatDetailState {
  const ChatDetailLoading();
}

class ChatDetailLoaded extends ChatDetailState {
  final List<MessageModel> messages;

  const ChatDetailLoaded({
    required this.messages,
  });

  ChatDetailLoaded copyWith({
    List<MessageModel>? messages,
  }) {
    return ChatDetailLoaded(
      messages: messages ?? this.messages,
    );
  }
}

class ChatDetailError extends ChatDetailState {
  final String message;
  const ChatDetailError(this.message);
}
