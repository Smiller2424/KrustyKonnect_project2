import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../connection/repositories/post_repository.dart';
import '../../connection/screens/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PostRepository _postRepository = PostRepository();

    return Scaffold(
      body: Column(
        children: [

          // HEADER
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  const Color(0xFF3A7BD5),
                  const Color(0xFF00B4DB),
                ],
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.only(left: 24, bottom: 20),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Feed",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // FEED CONTENT
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _postRepository.getPosts(), 
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No posts yet"),
                  );
                }

                final posts = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post =
                        posts[index].data() as Map<String, dynamic>;

                    //  USING POST CARD
                    return PostCard(post: post);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}