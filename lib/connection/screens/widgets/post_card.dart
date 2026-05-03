import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../social/screens/comments_screen.dart';
import '../../../connection/repositories/post_repository.dart';

class PostCard extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostCard({super.key, required this.post});

  // TIME FORMAT FUNCTION
  String formatTime(Timestamp timestamp) {
    final now = DateTime.now();
    final date = timestamp.toDate();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return "Just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes}m ago";
    if (diff.inHours < 24) return "${diff.inHours}h ago";
    return "${diff.inDays}d ago";
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = post['imageUrl'] != null &&
        post['imageUrl'].toString().isNotEmpty;

    final hasCaption = post['caption'] != null &&
        post['caption'].toString().isNotEmpty;

    final userId = FirebaseAuth.instance.currentUser?.uid;
    final likes = post['likes'] ?? [];
    final isLiked = likes.contains(userId);
    final repo = PostRepository();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          //  USER + TIME
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                post['userEmail'] ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

              if (post['createdAt'] != null)
                Text(
                  formatTime(post['createdAt']),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 10),

          //  IMAGE
          if (hasImage)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                post['imageUrl'],
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),

          if (hasImage) const SizedBox(height: 10),

          //  CAPTION
          if (hasCaption)
            Text(
              post['caption'],
              style: const TextStyle(fontSize: 14),
            ),

          const SizedBox(height: 10),

          //  ACTION ROW (UPDATED)
          Row(
            children: [

              // ❤️ LIKE BUTTON
              IconButton(
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : null,
                ),
                onPressed: userId == null
                    ? null
                    : () {
                        repo.toggleLike(post['id'], userId);
                      },
              ),

              Text("${likes.length}"),

              const SizedBox(width: 16),

              //  COMMENT BUTTON
              IconButton(
                icon: const Icon(Icons.comment_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CommentsScreen(
                        postId: post['id'],
                      ),
                    ),
                  );
                },
              ),

              const Text("Comment"),
            ],
          ),
        ],
      ),
    );
  }
}