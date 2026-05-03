import 'package:cloud_firestore/cloud_firestore.dart';

class PostRepository {
  final CollectionReference _posts =
      FirebaseFirestore.instance.collection('posts');

  //  CREATE POST
  Future<void> createPost(Map<String, dynamic> data) async {
    await _posts.add(data);
  }

  Future<void> toggleLike(String postId, String userId) async {
  final doc = _posts.doc(postId);

  final snapshot = await doc.get();
  final data = snapshot.data() as Map<String, dynamic>;

  List likes = data['likes'] ?? [];

  if (likes.contains(userId)) {
    likes.remove(userId);
  } else {
    likes.add(userId);
  }

  await doc.update({'likes': likes});
}

  //  GET POSTS (REAL-TIME)
  Stream<QuerySnapshot> getPosts() {
    return _posts
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

    //  ADD COMMENT
  Future<void> addComment(String postId, Map<String, dynamic> data) async {
    await _posts.doc(postId).collection('comments').add(data);
  }

  // GET COMMENTS (REAL-TIME)
  Stream<QuerySnapshot> getComments(String postId) {
    return _posts
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}