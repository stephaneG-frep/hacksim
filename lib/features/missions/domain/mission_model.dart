class MissionStep {
  const MissionStep({
    required this.title,
    required this.prompt,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
    this.terminalSnippet,
  });

  final String title;
  final String prompt;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;
  final String? terminalSnippet;
}

class MissionModel {
  const MissionModel({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.category,
    required this.xpReward,
    required this.scenario,
    required this.steps,
    required this.requiredXp,
    required this.prerequisiteCourses,
  });

  final String id;
  final String title;
  final String difficulty;
  final String category;
  final int xpReward;
  final String scenario;
  final List<MissionStep> steps;
  final int requiredXp;
  final List<String> prerequisiteCourses;
}
