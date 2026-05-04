import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../repositories/chat_repository.dart';
import '../services/match_service.dart';
import '../services/user_service.dart';
import 'chat_screen.dart';
import 'widgets/match_card.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  final UserService _userService = UserService();
  final ChatRepository _chatRepository = ChatRepository();

  bool _isLoading = true;
  List<MatchResult> _matches = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  Future<void> _loadMatches() async {
    try {
      final users = await _userService.getAllUsers();
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;

      if (currentUserId == null) {
        setState(() {
          _error = 'You must be logged in to view matches.';
          _isLoading = false;
        });
        return;
      }

      if (users.isEmpty) {
        setState(() {
          _error = 'No users found in Firestore.';
          _isLoading = false;
        });
        return;
      }

      final currentUser = users.firstWhere(
        (user) => user['id'] == currentUserId,
        orElse: () => {},
      );

      if (currentUser.isEmpty) {
        setState(() {
          _error = 'Current user profile was not found in Firestore.';
          _isLoading = false;
        });
        return;
      }

      final matches = MatchService.findMatches(
        currentUser: currentUser,
        candidates: users,
      );

      setState(() {
        _matches = matches.take(5).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load matches: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _openChat(MatchResult match) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final otherUserId = match.user['id'];

    if (currentUserId == null || otherUserId == null) return;

    final chatId = await _chatRepository.createOrOpenChat(
      currentUserId: currentUserId,
      otherUserId: otherUserId,
    );

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          chatId: chatId,
          otherUserName: match.user['name'] ?? 'Chat',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Partner Matches'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      _error!,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : _matches.isEmpty
                  ? const Center(
                      child: Text('No matches available.'),
                    )
                  : ListView.builder(
                      itemCount: _matches.length,
                      itemBuilder: (context, index) {
                        return MatchCard(
                          match: _matches[index],
                          onTap: () => _openChat(_matches[index]),
                        );
                      },
                    ),
    );
  }
}
