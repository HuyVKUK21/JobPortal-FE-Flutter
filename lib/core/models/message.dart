enum MessageType {
  text,
  image,
  file,
}

enum MessageSender {
  user,
  company,
}

class Message {
  final String id;
  final String content;
  final MessageSender sender;
  final DateTime timestamp;
  final bool isRead;
  final MessageType type;
  final String? imageUrl;
  final String? fileName;

  Message({
    required this.id,
    required this.content,
    required this.sender,
    required this.timestamp,
    this.isRead = false,
    this.type = MessageType.text,
    this.imageUrl,
    this.fileName,
  });

  Message copyWith({
    String? id,
    String? content,
    MessageSender? sender,
    DateTime? timestamp,
    bool? isRead,
    MessageType? type,
    String? imageUrl,
    String? fileName,
  }) {
    return Message(
      id: id ?? this.id,
      content: content ?? this.content,
      sender: sender ?? this.sender,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      fileName: fileName ?? this.fileName,
    );
  }
}
