class ChatMessage {
  final String id;
  final String content;
  final DateTime timestamp;
  final bool isMe;

  ChatMessage({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.isMe,
  });
}
