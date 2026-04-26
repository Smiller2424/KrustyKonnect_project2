import 'package:cloud_firestore/cloud_firestore.dart';
import '../repositories/chat_repository.dart';

class ChatService {
  ChatService({ChatRepository? repository})
      : _repository = repository ?? ChatRepository();

  final ChatRepository _repository;

  Future<String> openChat({
    required String currentUserId,
    required String otherUserId,
  }) {
    return _repository.createOrOpenChat(
      currentUserId: currentUserId,
      otherUserId: otherUserId,
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserChats(
    String currentUserId,
  ) {
    return _repository.watchUserChats(currentUserId);
  }

  Future<Map<String, dynamic>?> getChatData(String chatId) async {
    final doc = await _repository.getChat(chatId);
    return doc.data();
  }
}
