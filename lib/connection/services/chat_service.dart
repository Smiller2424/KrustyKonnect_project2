import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserChats() {
    //safe guarding chat screem
    final userId = currentUserId;
    if (userId == null) {
      return const Stream.empty();
    }
    
    return _firestore
        .collection('chats')
        .where('memberIds', arrayContains: currentUserId)
        .orderBy('lastMessageAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> sendMessage({
    required String chatId,
    required String text,
  }) async {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty) return;

    await _firestore.collection('chats').doc(chatId).collection('messages').add({
      'senderId': currentUserId,
      'text': trimmedText,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': trimmedText,
      'lastMessageAt': FieldValue.serverTimestamp(),
    });
  }
}
