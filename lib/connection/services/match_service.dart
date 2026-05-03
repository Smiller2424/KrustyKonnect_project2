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
    if (value is List) return List<String>.from(value);
    if (value is String) return [value];
    return [];
  }

  static List<MatchResult> findMatches({
    required Map<String, dynamic> currentUser,
    required List<Map<String, dynamic>> candidates,
  }) {
    List<MatchResult> results = [];

    for (var candidate in candidates) {
      // skip self
      if (candidate['id'] == currentUser['id']) continue;

      int score = 0;
      List<String> reasons = [];

      // --- courses ---
      List<String> currentCourses = _safeList(currentUser['courses']);
      List<String> candidateCourses = _safeList(candidate['courses']);

      var sharedCourses =
          currentCourses.where((c) => candidateCourses.contains(c)).toList();

      if (sharedCourses.isNotEmpty) {
        int courseScore = sharedCourses.length * 3;
        score += courseScore;
        reasons.add("${sharedCourses.length} shared course(s)");
      }

      // --- availability ---
      List<String> currentAvailability = _safeList(currentUser['availability']);
      List<String> candidateAvailability = _safeList(candidate['availability']);

      var sharedAvailability = currentAvailability
          .where((a) => candidateAvailability.contains(a))
          .toList();

      if (sharedAvailability.isNotEmpty) {
        int availabilityScore = sharedAvailability.length * 2;
        score += availabilityScore;
        reasons.add("${sharedAvailability.length} overlapping time slot(s)");
      }

      // --- interests ---
      List<String> currentInterests = _safeList(currentUser['interests']);
      List<String> candidateInterests = _safeList(candidate['interests']);

      var sharedInterests = currentInterests
          .where((i) => candidateInterests.contains(i))
          .toList();

      if (sharedInterests.isNotEmpty) {
        int interestScore = sharedInterests.length * 1;
        score += interestScore;
        reasons.add("${sharedInterests.length} shared interest(s)");
      }

      results.add(
        MatchResult(
          user: candidate,
          score: score,
          reasons: reasons,
        ),
      );
    }

    // sort highest score first
    results.sort((a, b) => b.score.compareTo(a.score));

    // return top 5
    return results.take(5).toList();
  }
}