import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          //  HEADER 
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

          //  FEED CONTENT
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
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
                    final post = posts[index].data() as Map<String, dynamic>;

                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
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

                          // IMAGE
                          if (post['imageUrl'] != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                post['imageUrl'],
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),

                          if (post['imageUrl'] != null)
                            const SizedBox(height: 10),

                          // CAPTION
                          if (post['caption'] != null &&
                              post['caption'].toString().isNotEmpty)
                            Text(post['caption']),

                        ],
                      ),
                    );
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