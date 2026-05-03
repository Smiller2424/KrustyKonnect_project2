import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
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

          // USER EMAIL
          Text(
            post['userEmail'] ?? '',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          // IMAGE (ONLY IF EXISTS)
          if (post['imageUrl'] != null &&
              post['imageUrl'].toString().isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                post['imageUrl'],
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),

          if (post['imageUrl'] != null &&
              post['imageUrl'].toString().isNotEmpty)
            const SizedBox(height: 10),

          //  CAPTION
          if (post['caption'] != null &&
              post['caption'].toString().isNotEmpty)
            Text(
              post['caption'],
              style: const TextStyle(fontSize: 14),
            ),
        ],
      ),
    );
  }
}