import 'package:flutter/foundation.dart';
import '../models/message.dart';

class ChatProvider extends ChangeNotifier {
  final List<Message> _messages = [];

  List<Message> get messages => _messages;

  void sendMessage(String senderId, String receiverId, String text) {
    if (text.trim().isEmpty) return;

    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: senderId,
      receiverId: receiverId,
      text: text,
      timestamp: DateTime.now(),
    );

    _messages.add(newMessage);
    notifyListeners();
  }

  List<Message> getConversation(String userId, String otherUserId) {
    return _messages
        .where(
          (m) =>
              (m.senderId == userId && m.receiverId == otherUserId) ||
              (m.senderId == otherUserId && m.receiverId == userId),
        )
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }
}
