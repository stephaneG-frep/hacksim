import '../domain/campaign_model.dart';

const List<CampaignModel> campaignsData = [
  CampaignModel(
    id: 'blue-team-starter',
    title: 'Blue Team Starter',
    description: 'Construire une base solide de détection, supervision et réponse à incident.',
    badgeName: 'Badge Blue Team Starter',
    steps: [
      CampaignStep(type: CampaignStepType.course, targetId: 'logs-monitoring', label: 'Cours: Logs et surveillance'),
      CampaignStep(type: CampaignStepType.mission, targetId: 'log-hunter', label: 'Mission: Log Hunter'),
      CampaignStep(type: CampaignStepType.course, targetId: 'incident-response', label: 'Cours: Incident response'),
      CampaignStep(type: CampaignStepType.mission, targetId: 'server-defense', label: 'Mission: Server Defense'),
    ],
  ),
  CampaignModel(
    id: 'appsec-path',
    title: 'AppSec Path',
    description: 'Sécuriser les applications web et API avec des pratiques défensives robustes.',
    badgeName: 'Badge AppSec Path',
    steps: [
      CampaignStep(type: CampaignStepType.course, targetId: 'sqli-awareness', label: 'Cours: SQL Injection Awareness'),
      CampaignStep(type: CampaignStepType.mission, targetId: 'sql-awareness-mission', label: 'Mission: SQL Injection Awareness'),
      CampaignStep(type: CampaignStepType.course, targetId: 'xss-web', label: 'Cours: XSS et sécurité web'),
      CampaignStep(type: CampaignStepType.course, targetId: 'api-security-essentials', label: 'Cours: API Security Essentials'),
      CampaignStep(type: CampaignStepType.mission, targetId: 'api-shield', label: 'Mission: API Shield'),
    ],
  ),
  CampaignModel(
    id: 'cloud-defender',
    title: 'Cloud Defender',
    description: 'Durcir identité cloud, exposition réseau et workloads conteneurisés.',
    badgeName: 'Badge Cloud Defender',
    steps: [
      CampaignStep(type: CampaignStepType.course, targetId: 'iam-basics', label: 'Cours: IAM'),
      CampaignStep(type: CampaignStepType.mission, targetId: 'iam-audit-rush', label: 'Mission: IAM Audit Rush'),
      CampaignStep(type: CampaignStepType.course, targetId: 'cloud-security-fundamentals', label: 'Cours: Fondamentaux sécurité cloud'),
      CampaignStep(type: CampaignStepType.mission, targetId: 'cloud-guardrails', label: 'Mission: Cloud Guardrails'),
      CampaignStep(type: CampaignStepType.course, targetId: 'container-security', label: 'Cours: Sécurité des conteneurs'),
    ],
  ),
  CampaignModel(
    id: 'incident-commander',
    title: 'Incident Commander',
    description: 'Piloter investigation, forensic et orchestration SOC en situation de crise simulée.',
    badgeName: 'Badge Incident Commander',
    steps: [
      CampaignStep(type: CampaignStepType.course, targetId: 'incident-response', label: 'Cours: Incident response'),
      CampaignStep(type: CampaignStepType.course, targetId: 'digital-forensics', label: 'Cours: Digital forensics'),
      CampaignStep(type: CampaignStepType.mission, targetId: 'forensics-war-room', label: 'Mission: Forensics War Room'),
      CampaignStep(type: CampaignStepType.course, targetId: 'soc-playbooks', label: 'Cours: SOC operations et playbooks'),
      CampaignStep(type: CampaignStepType.mission, targetId: 'secure-release', label: 'Mission: Secure Release Gate'),
    ],
  ),
];
