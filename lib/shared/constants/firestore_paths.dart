class FirestorePaths {
  static const String users = 'users';
  static const String posts = 'posts';
  static const String chats = 'chats';
  static const String events = 'events';

  static String comments(String postId) => 'posts/$postId/comments';
  static String messages(String chatId) => 'chats/$chatId/messages';
}
