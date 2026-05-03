import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../connection/repositories/post_repository.dart';
import '../../connection/screens/widgets/comment_tile.dart';

class CommentsScreen extends StatefulWidget {
  final String postId;

  const CommentsScreen({super.key, required this.postId});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final commentController = TextEditingController();
  final PostRepository _repo = PostRepository();

  bool isLoading = false;

  Future<void> addComment() async {
    final user = FirebaseAuth.instance.currentUser;
    final text = commentController.text.trim();

    if (user == null || text.isEmpty) return;

    setState(() => isLoading = true);

    try {
      //  USING REPOSITORY INSTEAD OF DIRECT FIRESTORE
      await _repo.addComment(widget.postId, {
        'userId': user.uid,
        'userEmail': user.email,
        'text': text,
        'createdAt': Timestamp.now(),
      });

      commentController.clear();

    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to add comment")),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Comments")),
      body: Column(
        children: [

          // COMMENTS LIST
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              //  USING REPOSITORY
              stream: _repo.getComments(widget.postId),
              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final comments = snapshot.data!.docs;

                if (comments.isEmpty) {
                  return const Center(
                    child: Text("No comments yet 💬"),
                  );
                }

                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment =
                        comments[index].data() as Map<String, dynamic>;

                    //  USING COMMENT TILE 
                    return CommentTile(comment: comment);
                  },
                );
              },
            ),
          ),

          // INPUT
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: const InputDecoration(
                      hintText: "Write a comment...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: isLoading ? null : addComment,
                  icon: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}