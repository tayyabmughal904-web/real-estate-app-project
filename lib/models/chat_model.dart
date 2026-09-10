class MessageItem {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool isFromMe;

  const MessageItem({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.isFromMe,
  });
}

class ChatConversation {
  final String id;
  final String agentId;
  final String agentName;
  final String agentAvatar;
  final String propertyTitle;
  final String propertyThumbnail;
  final List<MessageItem> messages;
  final int unreadCount;

  const ChatConversation({
    required this.id,
    required this.agentId,
    required this.agentName,
    required this.agentAvatar,
    required this.propertyTitle,
    required this.propertyThumbnail,
    required this.messages,
    this.unreadCount = 0,
  });

  String get lastMessage => messages.isNotEmpty ? messages.last.text : '';
  DateTime get lastMessageTime => messages.isNotEmpty ? messages.last.timestamp : DateTime.now();

  ChatConversation copyWith({
    String? id,
    String? agentId,
    String? agentName,
    String? agentAvatar,
    String? propertyTitle,
    String? propertyThumbnail,
    List<MessageItem>? messages,
    int? unreadCount,
  }) {
    return ChatConversation(
      id: id ?? this.id,
      agentId: agentId ?? this.agentId,
      agentName: agentName ?? this.agentName,
      agentAvatar: agentAvatar ?? this.agentAvatar,
      propertyTitle: propertyTitle ?? this.propertyTitle,
      propertyThumbnail: propertyThumbnail ?? this.propertyThumbnail,
      messages: messages ?? this.messages,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
