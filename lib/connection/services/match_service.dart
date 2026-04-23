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
      List<String> currentCourses =
          List<String>.from(currentUser['courses'] ?? []);
      List<String> candidateCourses =
          List<String>.from(candidate['courses'] ?? []);

      var sharedCourses =
          currentCourses.where((c) => candidateCourses.contains(c)).toList();

      if (sharedCourses.isNotEmpty) {
        int courseScore = sharedCourses.length * 3;
        score += courseScore;
        reasons.add("${sharedCourses.length} shared course(s)");
      }

      // --- availability ---
      List<String> currentAvailability =
          List<String>.from(currentUser['availability'] ?? []);
      List<String> candidateAvailability =
          List<String>.from(candidate['availability'] ?? []);

      var sharedAvailability = currentAvailability
          .where((a) => candidateAvailability.contains(a))
          .toList();

      if (sharedAvailability.isNotEmpty) {
        int availabilityScore = sharedAvailability.length * 2;
        score += availabilityScore;
        reasons.add("${sharedAvailability.length} overlapping time slot(s)");
      }

      // --- interests ---
      List<String> currentInterests =
          List<String>.from(currentUser['interests'] ?? []);
      List<String> candidateInterests =
          List<String>.from(candidate['interests'] ?? []);

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
