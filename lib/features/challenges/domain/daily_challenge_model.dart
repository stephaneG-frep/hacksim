class DailyChallengeModel {
  const DailyChallengeModel({
    required this.templateId,
    required this.title,
    required this.category,
    required this.prompt,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
    required this.xpReward,
  });

  final String templateId;
  final String title;
  final String category;
  final String prompt;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;
  final int xpReward;

  String idForDate(DateTime date) {
    final day =
        '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return 'daily-$day-$templateId';
  }
}
