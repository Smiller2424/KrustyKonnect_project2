import 'package:flutter/material.dart';
import '../../services/match_service.dart';

class MatchCard extends StatelessWidget {
  final MatchResult match;

  const MatchCard({
    super.key,
    required this.match,
  });

  @override 
  Widget build(BuildContext context) {
    final user = match.user;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user['name'] ?? 'Unknown User',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(user['major'] ?? 'No Major Listed.'),
            const SizedBox(height: 8),
            Text(
              'Match Score: ${match.score}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'Reasons for matching:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            ...match.reasons.map(
              (reason) => Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text('- $reason'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
