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
}
