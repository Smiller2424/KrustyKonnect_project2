class Post {
  final String id;
  final String userId;
  final String userEmail;
  final String caption;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.caption,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userEmail': userEmail,
      'caption': caption,
      'createdAt': createdAt,
    };
  }

  factory Post.fromMap(String id, Map<String, dynamic> map) {
    return Post(
      id: id,
      userId: map['userId'] ?? '',
      userEmail: map['userEmail'] ?? '',
      caption: map['caption'] ?? '',
      createdAt: (map['createdAt'] as dynamic).toDate(),
    );
  }
}