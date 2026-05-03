import 'package:cloud_firestore/cloud_firestore.dart';

class PostRepository {
  final _collection = FirebaseFirestore.instance.collection('posts');

  Future<void> createPost(Map<String, dynamic> data) async {
    await _collection.add(data);
  }
}