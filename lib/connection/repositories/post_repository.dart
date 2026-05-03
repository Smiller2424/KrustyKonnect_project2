import 'package:cloud_firestore/cloud_firestore.dart';

class PostRepository {
  final CollectionReference _posts =
      FirebaseFirestore.instance.collection('posts');

  //  CREATE POST
  Future<void> createPost(Map<String, dynamic> data) async {
    await _posts.add(data);
  }

  //  GET POSTS (REAL-TIME)
  Stream<QuerySnapshot> getPosts() {
    return _posts
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}