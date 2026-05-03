import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String userId;
  final String? userEmail;
  final String? caption;
  final String? imageUrl;
  final Timestamp? createdAt;
  final List<dynamic> likes;

  Post({
    required this.id,
    required this.userId,
    this.userEmail,
    this.caption,
    this.imageUrl,
    this.createdAt,
    this.likes = const [],
  });

  //  Convert Firestore → Post
  factory Post.fromMap(String id, Map<String, dynamic> data) {
    return Post(
      id: id,
      userId: data['userId'] ?? '',
      userEmail: data['userEmail'],
      caption: data['caption'],
      imageUrl: data['imageUrl'],
      createdAt: data['createdAt'],
      likes: data['likes'] ?? [],
    );
  }

  //  Convert Post → Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userEmail': userEmail,
      'caption': caption,
      'imageUrl': imageUrl,
      'createdAt': createdAt ?? Timestamp.now(),
      'likes': likes,
    };
  }
}