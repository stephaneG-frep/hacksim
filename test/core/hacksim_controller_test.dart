import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hacksim/core/state/hacksim_controller.dart';

// Helpers pour construire des IDs de défis quotidiens dans le format attendu.
String _challengeId(DateTime date, {String suffix = 'test'}) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return 'daily-$y-$m-$d-$suffix';
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  // ---------------------------------------------------------------------------
  // XP & Niveau
  // ---------------------------------------------------------------------------
  group('XP et niveau', () {
    test('niveau 1 à 0 XP', () async {
      SharedPreferences.setMockInitialValues({'total_xp': 0});
      final c = await HackSimController.create();
      expect(c.level, 1);
    });

    test('niveau augmente tous les 200 XP', () async {
      SharedPreferences.setMockInitialValues({'total_xp': 200});
      final c = await HackSimController.create();
      expect(c.level, 2);
    });

    test('validateQuiz ajoute XP et marque le cours validé', () async {
      final c = await HackSimController.create();
      await c.validateQuiz(courseId: 'cours-test', xpReward: 50);
      expect(c.totalXp, 50);
      expect(c.isQuizValidated('cours-test'), isTrue);
    });

    test('validateQuiz idempotent : XP non doublé', () async {
      final c = await HackSimController.create();
      await c.validateQuiz(courseId: 'cours-test', xpReward: 50);
      await c.validateQuiz(courseId: 'cours-test', xpReward: 50);
      expect(c.totalXp, 50);
    });

    test('completeMission ajoute XP et marque la mission terminée', () async {
      final c = await HackSimController.create();
      await c.completeMission(missionId: 'mission-test', xpReward: 100);
      expect(c.totalXp, 100);
      expect(c.isMissionCompleted('mission-test'), isTrue);
    });

    test('completeMission idempotent', () async {
      final c = await HackSimController.create();
      await c.completeMission(missionId: 'm1', xpReward: 100);
      await c.completeMission(missionId: 'm1', xpReward: 100);
      expect(c.totalXp, 100);
    });
  });

  // ---------------------------------------------------------------------------
  // Badges
  // ---------------------------------------------------------------------------
  group('Badges', () {
    test('aucun badge à 0 XP', () async {
      final c = await HackSimController.create();
      expect(c.badges, isEmpty);
    });

    test('badge Cadet Cyber à 100 XP exactement', () async {
      SharedPreferences.setMockInitialValues({'total_xp': 100});
      final c = await HackSimController.create();
      expect(c.badges.contains('Cadet Cyber'), isTrue);
    });

    test('pas de badge Cadet Cyber à 99 XP', () async {
      SharedPreferences.setMockInitialValues({'total_xp': 99});
      final c = await HackSimController.create();
      expect(c.badges.contains('Cadet Cyber'), isFalse);
    });

    test('badge Apprenant Régulier après 4 quiz validés', () async {
      final c = await HackSimController.create();
      for (var i = 0; i < 4; i++) {
        await c.validateQuiz(courseId: 'cours-$i', xpReward: 10);
      }
      expect(c.badges.contains('Apprenant Régulier'), isTrue);
    });

    test('pas de badge Apprenant Régulier avec 3 quiz seulement', () async {
      final c = await HackSimController.create();
      for (var i = 0; i < 3; i++) {
        await c.validateQuiz(courseId: 'cours-$i', xpReward: 10);
      }
      expect(c.badges.contains('Apprenant Régulier'), isFalse);
    });

    test('badge Analyste Réseau après mission port-scan-basics', () async {
      final c = await HackSimController.create();
      await c.completeMission(missionId: 'port-scan-basics', xpReward: 0);
      expect(c.badges.contains('Analyste Réseau'), isTrue);
    });

    test('badge Défenseur Terrain après 3 missions', () async {
      final c = await HackSimController.create();
      for (var i = 0; i < 3; i++) {
        await c.completeMission(missionId: 'mission-$i', xpReward: 0);
      }
      expect(c.badges.contains('Défenseur Terrain'), isTrue);
    });

    test('badge Architecte de Défense à 1200 XP', () async {
      SharedPreferences.setMockInitialValues({'total_xp': 1200});
      final c = await HackSimController.create();
      expect(c.badges.contains('Architecte de Défense'), isTrue);
    });

    test('resetProgress efface les badges', () async {
      SharedPreferences.setMockInitialValues({'total_xp': 1200});
      final c = await HackSimController.create();
      expect(c.badges, isNotEmpty);
      await c.resetProgress();
      expect(c.badges, isEmpty);
      expect(c.totalXp, 0);
    });
  });

  // ---------------------------------------------------------------------------
  // Streak quotidien
  // ---------------------------------------------------------------------------
  group('Streak quotidien', () {
    test('streak 0 sans défis complétés', () async {
      final c = await HackSimController.create();
      expect(c.currentDailyStreak, 0);
      expect(c.bestDailyStreak, 0);
    });

    test('streak 1 avec défi complété hier seulement', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      SharedPreferences.setMockInitialValues({
        'completed_daily_challenges': [_challengeId(yesterday)],
      });
      final c = await HackSimController.create();
      expect(c.currentDailyStreak, 1);
    });

    test('streak 2 avec défis hier et avant-hier', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final twoDaysAgo = DateTime.now().subtract(const Duration(days: 2));
      SharedPreferences.setMockInitialValues({
        'completed_daily_challenges': [
          _challengeId(yesterday),
          _challengeId(twoDaysAgo),
        ],
      });
      final c = await HackSimController.create();
      expect(c.currentDailyStreak, 2);
    });

    test('streak réinitialise si gap d\'un jour', () async {
      final threeDaysAgo = DateTime.now().subtract(const Duration(days: 3));
      final fourDaysAgo = DateTime.now().subtract(const Duration(days: 4));
      SharedPreferences.setMockInitialValues({
        'completed_daily_challenges': [
          _challengeId(threeDaysAgo),
          _challengeId(fourDaysAgo),
        ],
      });
      final c = await HackSimController.create();
      expect(c.currentDailyStreak, 0);
    });

    test('meilleur streak calculé correctement', () async {
      final d1 = DateTime.now().subtract(const Duration(days: 10));
      final d2 = DateTime.now().subtract(const Duration(days: 9));
      final d3 = DateTime.now().subtract(const Duration(days: 8));
      // gap ici
      final d5 = DateTime.now().subtract(const Duration(days: 6));
      SharedPreferences.setMockInitialValues({
        'completed_daily_challenges': [
          _challengeId(d1),
          _challengeId(d2),
          _challengeId(d3),
          _challengeId(d5),
        ],
      });
      final c = await HackSimController.create();
      expect(c.bestDailyStreak, 3);
    });

    test('badge Sentinelle Quotidienne après 1 défi', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      SharedPreferences.setMockInitialValues({
        'completed_daily_challenges': [_challengeId(yesterday)],
      });
      final c = await HackSimController.create();
      expect(c.badges.contains('Sentinelle Quotidienne'), isTrue);
    });

    test('badge Rituel Cyber après 7 défis au total', () async {
      final days = List.generate(7, (i) => DateTime.now().subtract(Duration(days: i + 1)));
      SharedPreferences.setMockInitialValues({
        'completed_daily_challenges': days.map(_challengeId).toList(),
      });
      final c = await HackSimController.create();
      expect(c.badges.contains('Rituel Cyber'), isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // Déverrouillage des missions
  // ---------------------------------------------------------------------------
  group('Déverrouillage des missions', () {
    test('une mission sans XP requis et sans prérequis est déverrouillée', () async {
      final c = await HackSimController.create();
      final mission = c.missions.firstWhere(
        (m) => m.requiredXp == 0 && m.prerequisiteCourses.isEmpty,
        orElse: () => c.missions.first,
      );
      if (mission.requiredXp == 0 && mission.prerequisiteCourses.isEmpty) {
        expect(c.isMissionUnlocked(mission), isTrue);
      }
    });

    test('une mission avec XP requis est verrouillée si XP insuffisant', () async {
      final c = await HackSimController.create();
      final lockedMission = c.missions.firstWhere(
        (m) => m.requiredXp > 0,
        orElse: () => c.missions.first,
      );
      if (lockedMission.requiredXp > 0) {
        expect(c.isMissionUnlocked(lockedMission), isFalse);
      }
    });
  });

  // ---------------------------------------------------------------------------
  // Progression globale
  // ---------------------------------------------------------------------------
  group('Progression globale', () {
    test('progression à 0 sans actions', () async {
      final c = await HackSimController.create();
      expect(c.globalProgress, 0.0);
    });

    test('progression augmente après validation d\'un quiz', () async {
      final c = await HackSimController.create();
      await c.validateQuiz(courseId: c.courses.first.id, xpReward: 10);
      expect(c.globalProgress, greaterThan(0.0));
    });

    test('updatePseudo met à jour le pseudo', () async {
      final c = await HackSimController.create();
      await c.updatePseudo('TestUser');
      expect(c.pseudo, 'TestUser');
    });

    test('pseudo vide revient à CyberCadet', () async {
      final c = await HackSimController.create();
      await c.updatePseudo('   ');
      expect(c.pseudo, 'CyberCadet');
    });
  });
}
