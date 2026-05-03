import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostService {
  Future<void> createPost(String caption, File? imageFile) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    String? imageUrl;

    //  Upload image if exists
    if (imageFile != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('posts')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      await ref.putFile(imageFile);

      imageUrl = await ref.getDownloadURL();
    }

    //  Save post
    await FirebaseFirestore.instance.collection('posts').add({
      'userId': user.uid,
      'userEmail': user.email,
      'caption': caption,
      'imageUrl': imageUrl,
      'createdAt': DateTime.now(),
    });
  }
}