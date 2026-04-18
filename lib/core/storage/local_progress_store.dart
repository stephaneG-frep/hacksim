import 'package:shared_preferences/shared_preferences.dart';

class LocalProgressSnapshot {
  const LocalProgressSnapshot({
    required this.completedCourses,
    required this.validatedQuizzes,
    required this.completedMissions,
    required this.completedDailyChallenges,
    required this.badges,
    required this.totalXp,
    required this.seasonXp,
    required this.pseudo,
  });

  final Set<String> completedCourses;
  final Set<String> validatedQuizzes;
  final Set<String> completedMissions;
  final Set<String> completedDailyChallenges;
  final Set<String> badges;
  final int totalXp;
  final int seasonXp;
  final String pseudo;
}

class LocalProgressStore {
  static const _completedCoursesKey = 'completed_courses';
  static const _validatedQuizzesKey = 'validated_quizzes';
  static const _completedMissionsKey = 'completed_missions';
  static const _completedDailyChallengesKey = 'completed_daily_challenges';
  static const _badgesKey = 'badges';
  static const _totalXpKey = 'total_xp';
  static const _seasonXpKey = 'season_xp';
  static const _pseudoKey = 'pseudo';

  Future<LocalProgressSnapshot> load() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalProgressSnapshot(
      completedCourses: (prefs.getStringList(_completedCoursesKey) ?? const []).toSet(),
      validatedQuizzes: (prefs.getStringList(_validatedQuizzesKey) ?? const []).toSet(),
      completedMissions: (prefs.getStringList(_completedMissionsKey) ?? const []).toSet(),
      completedDailyChallenges: (prefs.getStringList(_completedDailyChallengesKey) ?? const []).toSet(),
      badges: (prefs.getStringList(_badgesKey) ?? const []).toSet(),
      totalXp: prefs.getInt(_totalXpKey) ?? 0,
      seasonXp: prefs.getInt(_seasonXpKey) ?? 0,
      pseudo: prefs.getString(_pseudoKey) ?? 'CyberCadet',
    );
  }

  Future<void> save(LocalProgressSnapshot snapshot) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_completedCoursesKey, snapshot.completedCourses.toList()..sort());
    await prefs.setStringList(_validatedQuizzesKey, snapshot.validatedQuizzes.toList()..sort());
    await prefs.setStringList(_completedMissionsKey, snapshot.completedMissions.toList()..sort());
    await prefs.setStringList(_completedDailyChallengesKey, snapshot.completedDailyChallenges.toList()..sort());
    await prefs.setStringList(_badgesKey, snapshot.badges.toList()..sort());
    await prefs.setInt(_totalXpKey, snapshot.totalXp);
    await prefs.setInt(_seasonXpKey, snapshot.seasonXp);
    await prefs.setString(_pseudoKey, snapshot.pseudo);
  }
}
