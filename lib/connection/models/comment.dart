import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String userId;
  final String? userEmail;
  final String text;
  final Timestamp? createdAt;

  Comment({
    required this.id,
    required this.userId,
    this.userEmail,
    required this.text,
    this.createdAt,
  });

  //  Convert Firestore → Comment
  factory Comment.fromMap(String id, Map<String, dynamic> data) {
    return Comment(
      id: id,
      userId: data['userId'] ?? '',
      userEmail: data['userEmail'],
      text: data['text'] ?? '',
      createdAt: data['createdAt'],
    );
  }

  //  Convert Comment → Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userEmail': userEmail,
      'text': text,
      'createdAt': createdAt ?? Timestamp.now(),
    };
  }
}