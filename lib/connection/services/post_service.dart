import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/post_repository.dart';

class PostService {
  final PostRepository _repo = PostRepository();

  Future<void> createPost(String caption) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || caption.isEmpty) return;

    await _repo.createPost({
      'userId': user.uid,
      'userEmail': user.email,
      'caption': caption,
      'createdAt': DateTime.now(),
    });
  }
}