class MissionStep {
  const MissionStep({
    required this.title,
    required this.prompt,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
    this.terminalSnippet,
    this.commandChallenge,
    this.commandHint,
    this.commandOutput,
  });

  final String title;
  final String prompt;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;
  final String? terminalSnippet;

  /// Si non-null, l'utilisateur doit saisir cette commande dans le terminal
  /// avant de pouvoir répondre aux options QCM.
  final String? commandChallenge;
  final String? commandHint;

  /// Sortie affichée dans le terminal après une commande correcte.
  final String? commandOutput;

  factory MissionStep.fromJson(Map<String, dynamic> json) {
    return MissionStep(
      title: json['title'] as String,
      prompt: json['prompt'] as String,
      options: List<String>.from(json['options'] as List),
      correctOptionIndex: json['correctOptionIndex'] as int,
      explanation: json['explanation'] as String,
      terminalSnippet: json['terminalSnippet'] as String?,
      commandChallenge: json['commandChallenge'] as String?,
      commandHint: json['commandHint'] as String?,
      commandOutput: json['commandOutput'] as String?,
    );
  }
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

  factory MissionModel.fromJson(Map<String, dynamic> json) {
    return MissionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      difficulty: json['difficulty'] as String,
      category: json['category'] as String,
      xpReward: json['xpReward'] as int,
      scenario: json['scenario'] as String,
      requiredXp: json['requiredXp'] as int,
      prerequisiteCourses: List<String>.from(json['prerequisiteCourses'] as List),
      steps: (json['steps'] as List).map((s) => MissionStep.fromJson(s as Map<String, dynamic>)).toList(),
    );
  }
}
