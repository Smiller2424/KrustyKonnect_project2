import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepository {
  ChatRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _chats =>
      _firestore.collection('chats');

  String buildChatId(String userAId, String userBId) {
    final ids = [userAId, userBId]..sort();
    return '${ids[0]}_${ids[1]}';
  }

  Future<String> createOrOpenChat({
    required String currentUserId,
    required String otherUserId,
  }) async {
    final chatId = buildChatId(currentUserId, otherUserId);
    final chatRef = _chats.doc(chatId);
    final snapshot = await chatRef.get();

    if (!snapshot.exists) {
      await chatRef.set({
        'participantIds': [currentUserId, otherUserId],
        'lastMessage': '',
        'lastMessageSenderId': '',
        'lastMessageAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    return chatId;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchUserChats(
    String currentUserId,
  ) {
    return _chats
        .where('participantIds', arrayContains: currentUserId)
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getChat(String chatId) {
    return _chats.doc(chatId).get();
  }
}

