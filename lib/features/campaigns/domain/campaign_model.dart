enum CampaignStepType { course, mission }

class CampaignStep {
  const CampaignStep({
    required this.type,
    required this.targetId,
    required this.label,
  });

  final CampaignStepType type;
  final String targetId;
  final String label;

  factory CampaignStep.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String;
    final type = typeStr == 'mission' ? CampaignStepType.mission : CampaignStepType.course;
    return CampaignStep(type: type, targetId: json['targetId'] as String, label: json['label'] as String);
  }
}

class CampaignModel {
  const CampaignModel({
    required this.id,
    required this.title,
    required this.description,
    required this.badgeName,
    required this.steps,
  });

  final String id;
  final String title;
  final String description;
  final String badgeName;
  final List<CampaignStep> steps;

  factory CampaignModel.fromJson(Map<String, dynamic> json) {
    return CampaignModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      badgeName: json['badgeName'] as String,
      steps: (json['steps'] as List).map((s) => CampaignStep.fromJson(s as Map<String, dynamic>)).toList(),
    );
  }
}
