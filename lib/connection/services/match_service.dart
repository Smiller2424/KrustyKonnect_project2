class MatchResult {
  final Map<String, dynamic> user;
  final int score;
  final List<String> reasons;

  MatchResult({
    required this.user,
    required this.score,
    required this.reasons,
  });
}

class MatchService {
  static List<String> _safeList(dynamic value) {
    if (value is List) {
      return value
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }

    if (value is String) {
      return value
          .split(',')
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }

    return [];
  }

  static bool _matches(String a, String b) {
    return a.trim().toLowerCase() == b.trim().toLowerCase();
  }

  static List<MatchResult> findMatches({
    required Map<String, dynamic> currentUser,
    required List<Map<String, dynamic>> candidates,
  }) {
    List<MatchResult> results = [];

    for (var candidate in candidates) {
      if (candidate['id'] == currentUser['id']) continue;

      int score = 0;
      List<String> reasons = [];

      List<String> currentCourses = _safeList(currentUser['courses']);
      List<String> candidateCourses = _safeList(candidate['courses']);

      var sharedCourses = currentCourses
          .where((course) =>
              candidateCourses.any((candidateCourse) => _matches(course, candidateCourse)))
          .toList();

      if (sharedCourses.isNotEmpty) {
        score += sharedCourses.length * 3;
        reasons.add('Shared course: ${sharedCourses.join(', ')}');
      }

      List<String> currentAvailability = _safeList(currentUser['availability']);
      List<String> candidateAvailability = _safeList(candidate['availability']);

      var sharedAvailability = currentAvailability
          .where((time) =>
              candidateAvailability.any((candidateTime) => _matches(time, candidateTime)))
          .toList();

      if (sharedAvailability.isNotEmpty) {
        score += sharedAvailability.length * 2;
        reasons.add('Overlapping availability: ${sharedAvailability.join(', ')}');
      }

      List<String> currentInterests = _safeList(currentUser['interests']);
      List<String> candidateInterests = _safeList(candidate['interests']);

      var sharedInterests = currentInterests
          .where((interest) =>
              candidateInterests.any((candidateInterest) => _matches(interest, candidateInterest)))
          .toList();

      if (sharedInterests.isNotEmpty) {
        score += sharedInterests.length;
        reasons.add('Shared interest: ${sharedInterests.join(', ')}');
      }

      results.add(
        MatchResult(
          user: candidate,
          score: score,
          reasons: reasons,
        ),
      );
    }

    results.sort((a, b) => b.score.compareTo(a.score));

    return results.take(5).toList();
  }
}