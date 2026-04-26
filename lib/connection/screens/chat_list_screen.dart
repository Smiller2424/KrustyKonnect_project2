import 'package:flutter/material.dart';
import '../services/chat_service.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({
    super.key,
    required this.currentUserId,
  });

  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    final chatService = ChatService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: StreamBuilder(
        stream: chatService.getUserChats(currentUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No conversations yet'),
            );
          }

          final chats = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index].data();

              final lastMessage = chat['lastMessage'] ?? '';
              final timestamp = chat['updatedAt'];

              return ListTile(
                title: Text('Chat ${index + 1}'),
                subtitle: Text(
                  lastMessage.isEmpty
                      ? 'Start a conversation'
                      : lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: timestamp != null
                    ? Text(
                        _formatTimestamp(timestamp),
                        style: const TextStyle(fontSize: 12),
                      )
                    : null,
                onTap: () {
                  // NEXT DAY (Day 4) → navigate to ChatScreen
                },
              );
            },
          );
        },
      ),
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    try {
      final date = timestamp.toDate();
      return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }
}
