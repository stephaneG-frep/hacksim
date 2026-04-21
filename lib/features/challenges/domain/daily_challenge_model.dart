class DailyChallengeModel {
  const DailyChallengeModel({
    required this.templateId,
    required this.title,
    required this.category,
    required this.learningFocus,
    required this.prompt,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
    required this.xpReward,
    this.requiredQuizIds = const [],
  });

  final String templateId;
  final String title;
  final String category;
  final String learningFocus;
  final String prompt;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;
  final int xpReward;
  final List<String> requiredQuizIds;

  factory DailyChallengeModel.fromJson(Map<String, dynamic> json) {
    return DailyChallengeModel(
      templateId: json['templateId'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      learningFocus: json['learningFocus'] as String,
      prompt: json['prompt'] as String,
      options: List<String>.from(json['options'] as List),
      correctOptionIndex: json['correctOptionIndex'] as int,
      explanation: json['explanation'] as String,
      xpReward: json['xpReward'] as int,
      requiredQuizIds: List<String>.from((json['requiredQuizIds'] as List?) ?? []),
    );
  }

  String idForDate(DateTime date) {
    final day =
        '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return 'daily-$day-$templateId';
  }
}
