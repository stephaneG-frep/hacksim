import 'package:flutter/foundation.dart';

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
  final Set<String> _badges = <String>{};

  int _totalXp = 0;
  String _pseudo = 'CyberCadet';

  static Future<HackSimController> create() async {
    final controller = HackSimController._(LocalProgressStore());
    await controller._load();
    return controller;
  }

  List<CourseModel> get courses => coursesData;
  List<MissionModel> get missions => missionsData;

  int get totalXp => _totalXp;
  String get pseudo => _pseudo;
  int get level => (_totalXp ~/ 200) + 1;

  Set<String> get completedCourseIds => Set<String>.unmodifiable(_completedCourses);
  Set<String> get validatedQuizIds => Set<String>.unmodifiable(_validatedQuizzes);
  Set<String> get completedMissionIds => Set<String>.unmodifiable(_completedMissions);
  Set<String> get badges => Set<String>.unmodifiable(_badges);

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
    _recomputeBadges();
    await _persistAndNotify();
  }

  Future<void> completeMission({required String missionId, required int xpReward}) async {
    if (_completedMissions.contains(missionId)) {
      return;
    }

    _completedMissions.add(missionId);
    _totalXp += xpReward;
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
    _badges
      ..clear()
      ..addAll(snapshot.badges);
    _totalXp = snapshot.totalXp;
    _pseudo = snapshot.pseudo;
    _recomputeBadges();
  }

  Future<void> _persistAndNotify() async {
    await _store.save(
      LocalProgressSnapshot(
        completedCourses: _completedCourses,
        validatedQuizzes: _validatedQuizzes,
        completedMissions: _completedMissions,
        badges: _badges,
        totalXp: _totalXp,
        pseudo: _pseudo,
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
}
