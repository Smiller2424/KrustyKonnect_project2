import 'package:flutter/material.dart';
import '../services/match_service.dart';
import '../services/user_service.dart';
import 'widgets/match_card.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  final UserService _userService = UserService();

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

      if (users.isEmpty) {
        setState(() {
          _error = 'No users found in Firestore.';
          _isLoading = false;
        });
        return;
      }

      final currentUser = users.first;

      final matches = MatchService.findMatches(
        currentUser: currentUser,
        candidates: users,
      );

      setState(() {
        _matches = matches;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load matches: $e';
        _isLoading = false;
      });
    }
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
                        return MatchCard(match: _matches[index]);
                      },
                    ),
    );
  }
}
