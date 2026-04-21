import 'package:flutter/foundation.dart';

import '../../features/challenges/data/daily_challenges_data.dart';
import '../../features/challenges/domain/daily_challenge_model.dart';
import '../../features/courses/data/courses_data.dart';
import '../../features/courses/domain/course_model.dart';
import '../../features/missions/data/missions_data.dart';
import '../../features/missions/domain/mission_model.dart';
import '../storage/local_progress_store.dart';

class HackSimController extends ChangeNotifier {
  HackSimController._(this._store);

  final LocalProgressStore _store;

  final Set<String> _completedCourses = <String>{};
  final Set<String> _validatedQuizzes = <String>{};
  final Set<String> _completedMissions = <String>{};
  final Set<String> _completedDailyChallenges = <String>{};
  final Set<String> _badges = <String>{};

  int _totalXp = 0;
  int _seasonXp = 0;
  String _pseudo = 'CyberCadet';
  bool _animationsEnabled = true;
  bool _soundEnabled = true;
  bool _showOnlyUnlockedDefault = false;
  bool _onboardingSeen = false;

  static Future<HackSimController> create() async {
    final controller = HackSimController._(LocalProgressStore());
    await controller._load();
    return controller;
  }

  List<CourseModel> get courses => coursesData;
  List<MissionModel> get missions => missionsData;

  int get totalXp => _totalXp;
  int get seasonXp => _seasonXp;
  String get pseudo => _pseudo;
  int get level => (_totalXp ~/ 200) + 1;
  DateTime get today => DateTime.now();
  bool get animationsEnabled => _animationsEnabled;
  bool get soundEnabled => _soundEnabled;
  bool get showOnlyUnlockedDefault => _showOnlyUnlockedDefault;
  bool get onboardingSeen => _onboardingSeen;

  Set<String> get completedCourseIds => Set<String>.unmodifiable(_completedCourses);
  Set<String> get validatedQuizIds => Set<String>.unmodifiable(_validatedQuizzes);
  Set<String> get completedMissionIds => Set<String>.unmodifiable(_completedMissions);
  Set<String> get completedDailyChallengeIds => Set<String>.unmodifiable(_completedDailyChallenges);
  Set<String> get badges => Set<String>.unmodifiable(_badges);

  List<DailyChallengeModel> get availableDailyChallenges {
    return dailyChallengeTemplates.where((challenge) {
      return challenge.requiredQuizIds.every(_validatedQuizzes.contains);
    }).toList();
  }

  DailyChallengeModel get todaysChallenge {
    final eligible = availableDailyChallenges;
    final pool = eligible.isNotEmpty
        ? eligible
        : dailyChallengeTemplates.where((challenge) => challenge.requiredQuizIds.isEmpty).toList();
    final finalPool = pool.isNotEmpty ? pool : dailyChallengeTemplates;
    final now = today;
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays + 1;
    final index = dayOfYear % finalPool.length;
    return finalPool[index];
  }

  String get seasonLabel {
    final month = today.month;
    final season = switch (month) {
      <= 3 => 'Saison Hiver',
      <= 6 => 'Saison Printemps',
      <= 9 => 'Saison Été',
      _ => 'Saison Automne',
    };
    return '$season ${today.year}';
  }

  int get completedDailyChallengesCount => _completedDailyChallenges.length;
  bool isDailyChallengeCompleted(String challengeId) => _completedDailyChallenges.contains(challengeId);
  int get currentDailyStreak => _computeCurrentStreak(_completedChallengeDays());
  int get bestDailyStreak => _computeBestStreak(_completedChallengeDays());

  CourseModel courseById(String id) => courses.firstWhere((course) => course.id == id);
  MissionModel missionById(String id) => missions.firstWhere((mission) => mission.id == id);

  bool isCourseUnlocked(CourseModel course) {
    if (course.prerequisites.isEmpty) {
      return true;
    }
    return course.prerequisites.every(_validatedQuizzes.contains);
  }

  bool isMissionUnlocked(MissionModel mission) {
    if (_totalXp < mission.requiredXp) {
      return false;
    }
    return mission.prerequisiteCourses.every(_validatedQuizzes.contains);
  }

  bool isCourseCompleted(String courseId) => _completedCourses.contains(courseId);
  bool isQuizValidated(String courseId) => _validatedQuizzes.contains(courseId);
  bool isMissionCompleted(String missionId) => _completedMissions.contains(missionId);

  double get globalProgress {
    final totalGoals = courses.length + missions.length;
    if (totalGoals == 0) {
      return 0;
    }
    final done = _validatedQuizzes.length + _completedMissions.length;
    return done / totalGoals;
  }

  Future<void> updatePseudo(String value) async {
    _pseudo = value.trim().isEmpty ? 'CyberCadet' : value.trim();
    await _persistAndNotify();
  }

  Future<void> setAnimationsEnabled(bool value) async {
    _animationsEnabled = value;
    await _persistAndNotify();
  }

  Future<void> setSoundEnabled(bool value) async {
    _soundEnabled = value;
    await _persistAndNotify();
  }

  Future<void> setShowOnlyUnlockedDefault(bool value) async {
    _showOnlyUnlockedDefault = value;
    await _persistAndNotify();
  }

  Future<void> markOnboardingSeen() async {
    if (_onboardingSeen) {
      return;
    }
    _onboardingSeen = true;
    await _persistAndNotify();
  }

  Future<void> resetProgress() async {
    _completedCourses.clear();
    _validatedQuizzes.clear();
    _completedMissions.clear();
    _completedDailyChallenges.clear();
    _badges.clear();
    _totalXp = 0;
    _seasonXp = 0;
    _recomputeBadges();
    await _persistAndNotify();
  }

  Future<void> markCourseStarted(String courseId) async {
    _completedCourses.add(courseId);
    await _persistAndNotify();
  }

  Future<void> validateQuiz({required String courseId, required int xpReward}) async {
    if (_validatedQuizzes.contains(courseId)) {
      return;
    }

    _validatedQuizzes.add(courseId);
    _completedCourses.add(courseId);
    _totalXp += xpReward;
    _seasonXp += xpReward;
    _recomputeBadges();
    await _persistAndNotify();
  }

  Future<void> completeMission({required String missionId, required int xpReward}) async {
    if (_completedMissions.contains(missionId)) {
      return;
    }

    _completedMissions.add(missionId);
    _totalXp += xpReward;
    _seasonXp += xpReward;
    _recomputeBadges();
    await _persistAndNotify();
  }

  Future<void> completeDailyChallenge() async {
    final challenge = todaysChallenge;
    final challengeId = challenge.idForDate(today);
    if (_completedDailyChallenges.contains(challengeId)) {
      return;
    }
    _completedDailyChallenges.add(challengeId);
    _totalXp += challenge.xpReward;
    _seasonXp += challenge.xpReward;
    _recomputeBadges();
    await _persistAndNotify();
  }

  Future<void> _load() async {
    final snapshot = await _store.load();
    _completedCourses
      ..clear()
      ..addAll(snapshot.completedCourses);
    _validatedQuizzes
      ..clear()
      ..addAll(snapshot.validatedQuizzes);
    _completedMissions
      ..clear()
      ..addAll(snapshot.completedMissions);
    _completedDailyChallenges
      ..clear()
      ..addAll(snapshot.completedDailyChallenges);
    _badges
      ..clear()
      ..addAll(snapshot.badges);
    _totalXp = snapshot.totalXp;
    _seasonXp = snapshot.seasonXp;
    _pseudo = snapshot.pseudo;
    _animationsEnabled = snapshot.animationsEnabled;
    _soundEnabled = snapshot.soundEnabled;
    _showOnlyUnlockedDefault = snapshot.showOnlyUnlockedDefault;
    _onboardingSeen = snapshot.onboardingSeen;
    _recomputeBadges();
  }

  Future<void> _persistAndNotify() async {
    await _store.save(
      LocalProgressSnapshot(
        completedCourses: _completedCourses,
        validatedQuizzes: _validatedQuizzes,
        completedMissions: _completedMissions,
        completedDailyChallenges: _completedDailyChallenges,
        badges: _badges,
        totalXp: _totalXp,
        seasonXp: _seasonXp,
        pseudo: _pseudo,
        animationsEnabled: _animationsEnabled,
        soundEnabled: _soundEnabled,
        showOnlyUnlockedDefault: _showOnlyUnlockedDefault,
        onboardingSeen: _onboardingSeen,
      ),
    );
    notifyListeners();
  }

  void _recomputeBadges() {
    final newBadges = <String>{};

    if (_totalXp >= 100) {
      newBadges.add('Cadet Cyber');
    }
    if (_validatedQuizzes.length >= 4) {
      newBadges.add('Apprenant Régulier');
    }
    if (_completedDailyChallenges.isNotEmpty) {
      newBadges.add('Sentinelle Quotidienne');
    }
    if (_completedDailyChallenges.length >= 7) {
      newBadges.add('Rituel Cyber');
    }
    if (currentDailyStreak >= 3) {
      newBadges.add('Streak 3 jours');
    }
    if (currentDailyStreak >= 7) {
      newBadges.add('Streak 7 jours');
    }
    if (_completedMissions.contains('port-scan-basics')) {
      newBadges.add('Analyste Réseau');
    }
    if (_completedMissions.length >= 3) {
      newBadges.add('Défenseur Terrain');
    }
    if (_totalXp >= 1200) {
      newBadges.add('Architecte de Défense');
    }

    _badges
      ..clear()
      ..addAll(newBadges);
  }

  List<DateTime> _completedChallengeDays() {
    final days = <DateTime>[];
    for (final id in _completedDailyChallenges) {
      final parsed = _extractDateFromChallengeId(id);
      if (parsed != null) {
        days.add(DateTime(parsed.year, parsed.month, parsed.day));
      }
    }
    days.sort((a, b) => a.compareTo(b));
    return days;
  }

  DateTime? _extractDateFromChallengeId(String id) {
    final parts = id.split('-');
    if (parts.length < 5 || parts.first != 'daily') {
      return null;
    }
    final year = int.tryParse(parts[1]);
    final month = int.tryParse(parts[2]);
    final day = int.tryParse(parts[3]);
    if (year == null || month == null || day == null) {
      return null;
    }
    return DateTime(year, month, day);
  }

  int _computeCurrentStreak(List<DateTime> days) {
    if (days.isEmpty) {
      return 0;
    }

    final normalizedToday = DateTime(today.year, today.month, today.day);
    final daySet = days.toSet();
    final hasToday = daySet.contains(normalizedToday);
    final start = hasToday ? normalizedToday : normalizedToday.subtract(const Duration(days: 1));
    if (!daySet.contains(start)) {
      return 0;
    }

    int streak = 0;
    DateTime cursor = start;
    while (daySet.contains(cursor)) {
      streak += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  int _computeBestStreak(List<DateTime> days) {
    if (days.isEmpty) {
      return 0;
    }
    int best = 1;
    int current = 1;
    for (int i = 1; i < days.length; i++) {
      final prev = days[i - 1];
      final curr = days[i];
      final isNextDay = curr.difference(prev).inDays == 1;
      if (isNextDay) {
        current += 1;
      } else if (curr != prev) {
        current = 1;
      }
      if (current > best) {
        best = current;
      }
    }
    return best;
  }
}
