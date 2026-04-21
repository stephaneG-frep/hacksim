import 'dart:convert';

import 'package:flutter/services.dart';

import '../../features/campaigns/data/campaigns_data.dart';
import '../../features/campaigns/domain/campaign_model.dart';
import '../../features/challenges/data/daily_challenges_data.dart';
import '../../features/challenges/domain/daily_challenge_model.dart';
import '../../features/courses/data/courses_data.dart';
import '../../features/courses/domain/course_model.dart';
import '../../features/missions/data/missions_data.dart';
import '../../features/missions/domain/mission_model.dart';

/// Charge le contenu depuis les assets JSON et fusionne avec les données embarquées.
/// Les assets JSON permettent d'ajouter du contenu sans recompiler l'app.
class ContentRepository {
  ContentRepository._();

  static Future<ContentRepository> load() async {
    final repo = ContentRepository._();
    await repo._init();
    return repo;
  }

  late List<CourseModel> _courses;
  late List<MissionModel> _missions;
  late List<CampaignModel> _campaigns;
  late List<DailyChallengeModel> _dailyChallenges;

  List<CourseModel> get courses => _courses;
  List<MissionModel> get missions => _missions;
  List<CampaignModel> get campaigns => _campaigns;
  List<DailyChallengeModel> get dailyChallenges => _dailyChallenges;

  Future<void> _init() async {
    _courses = [...coursesData, ...await _loadCourses()];
    _missions = [...missionsData, ...await _loadMissions()];
    _campaigns = [...campaignsData, ...await _loadCampaigns()];
    _dailyChallenges = [...dailyChallengeTemplates, ...await _loadDailyChallenges()];
  }

  Future<List<CourseModel>> _loadCourses() async {
    return _loadList(
      'assets/content/courses_extra.json',
      (json) => CourseModel.fromJson(json),
    );
  }

  Future<List<MissionModel>> _loadMissions() async {
    return _loadList(
      'assets/content/missions_extra.json',
      (json) => MissionModel.fromJson(json),
    );
  }

  Future<List<CampaignModel>> _loadCampaigns() async {
    return _loadList(
      'assets/content/campaigns_extra.json',
      (json) => CampaignModel.fromJson(json),
    );
  }

  Future<List<DailyChallengeModel>> _loadDailyChallenges() async {
    return _loadList(
      'assets/content/challenges_extra.json',
      (json) => DailyChallengeModel.fromJson(json),
    );
  }

  Future<List<T>> _loadList<T>(String assetPath, T Function(Map<String, dynamic>) fromJson) async {
    try {
      final raw = await rootBundle.loadString(assetPath);
      final list = jsonDecode(raw) as List;
      return list.map((item) => fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      // Asset absent ou malformé : on ignore silencieusement.
      return [];
    }
  }
}
