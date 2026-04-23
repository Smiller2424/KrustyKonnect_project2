class Message {
  final String id;
  final String senderId;
  final String text;
  final DateTime? timestamp;

  Message({
    required this.id,
    required this.senderId,
    required this.text,
    this.timestamp,
  });

  factory Message.fromMap(String id, Map<String, dynamic> map) {
    return Message(
      id: id,
      senderId: map['senderId'] ?? '',
      text: map['text'] ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp?.toIso8601String(),
    };
  }
}