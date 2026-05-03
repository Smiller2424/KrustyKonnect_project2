import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentTile extends StatelessWidget {
  final Map<String, dynamic> comment;

  const CommentTile({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    final Timestamp? timestamp = comment['createdAt'];
    final DateTime? date = timestamp?.toDate();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          //  AVATAR (simple circle)
          const CircleAvatar(
            radius: 18,
            child: Icon(Icons.person, size: 18),
          ),

          const SizedBox(width: 10),

          //  COMMENT CONTENT
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // USER EMAIL
                  Text(
                    comment['userEmail'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // COMMENT TEXT
                  Text(
                    comment['text'] ?? '',
                    style: const TextStyle(fontSize: 14),
                  ),

                  const SizedBox(height: 4),

                  // TIME
                  if (date != null)
                    Text(
                      date.toString(),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}