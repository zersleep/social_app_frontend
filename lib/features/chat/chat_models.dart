class ChatStory {
  final String name;
  final String avatar;
  final bool isYourStory;

  const ChatStory({
    required this.name,
    required this.avatar,
    this.isYourStory = false,
  });
}

class ChatMessage {
  final String name;
  final String avatar;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;

  const ChatMessage({
    required this.name,
    required this.avatar,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.isOnline = false,
  });
}
