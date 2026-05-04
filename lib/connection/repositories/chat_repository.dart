import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createOrOpenChat({
    required String currentUserId,
    required String otherUserId,
  }) async {
    final chatsRef = _firestore.collection('chats');

    final query = await chatsRef
        .where('participantIds', arrayContains: currentUserId)
        .get();

    for (var doc in query.docs) {
      final data = doc.data();
      final participants = List<String>.from(data['participantIds'] ?? []);

      if (participants.contains(otherUserId)) {
        return doc.id;
      }
    }

    final newChat = await chatsRef.add({
      'participantIds': [currentUserId, otherUserId],
      'lastMessage': '',
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return newChat.id;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchUserChats(
    String currentUserId,
  ) {
    return _firestore
        .collection('chats')
        .where('participantIds', arrayContains: currentUserId)
        .snapshots();
  }
}
