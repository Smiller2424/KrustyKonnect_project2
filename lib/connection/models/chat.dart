class Chat {
  final String id;
  final List<String> participantIds;
  final String lastMessage;
  final DateTime? lastMessageTime;

  Chat({
    required this.id,
    required this.participantIds,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  factory Chat.fromMap(String id, Map<String, dynamic> map) {
    return Chat(
      id: id,
      participantIds: List<String>.from(map['participantIds'] ?? []),
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: map['lastMessageTime'] != null
        ? DateTime.parse(map['lastMessageTime'])
        : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'particapntIds': participantIds,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime?.toIso8601String(),
    };
  }
}