import 'package:flutter/material.dart';

import '../../../core/state/hacksim_controller.dart';
import '../../../core/widgets/cyber_screen.dart';
import '../../campaigns/domain/campaign_model.dart';
import '../../courses/presentation/course_detail_screen.dart';
import '../../missions/presentation/mission_detail_screen.dart';

class CampaignsScreen extends StatelessWidget {
  const CampaignsScreen({
    super.key,
    required this.controller,
    this.embedded = false,
  });

  static const routeName = '/campaigns';

  final HackSimController controller;
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final content = ListView(
      children: [
        AnimatedCyberCard(
          order: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Mode Campagne', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              const Text('Suis un parcours guidé. Chaque jalon validé fait avancer ta campagne.'),
            ],
          ),
        ),
        ...controller.campaigns.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final campaign = entry.value;
          final progress = controller.campaignProgress(campaign);
          final doneCount = campaign.steps.where(controller.isCampaignStepCompleted).length;
          final nextStep = controller.nextCampaignStep(campaign);

          return AnimatedCyberCard(
            order: index,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(campaign.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(campaign.description),
                const SizedBox(height: 10),
                LinearProgressIndicator(value: progress),
                const SizedBox(height: 8),
                Text('${(progress * 100).round()}% • $doneCount/${campaign.steps.length} jalons'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(label: Text(campaign.badgeName)),
                    if (controller.isCampaignCompleted(campaign)) const Chip(label: Text('Terminé')),
                  ],
                ),
                const SizedBox(height: 8),
                ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: EdgeInsets.zero,
                  title: const Text('Voir les jalons'),
                  children: campaign.steps.map((step) {
                    final complete = controller.isCampaignStepCompleted(step);
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        complete ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                        color: complete ? Colors.greenAccent : Colors.white70,
                      ),
                      title: Text(step.label),
                      subtitle: Text(step.type == CampaignStepType.course ? 'Cours' : 'Mission'),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: nextStep == null
                      ? null
                      : () => _openStep(context, nextStep),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text(nextStep == null ? 'Campagne terminée' : 'Ouvrir prochain objectif'),
                ),
              ],
            ),
          );
        }),
      ],
    );

    if (embedded) {
      return CyberScreen(child: content);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Campagnes')),
      body: CyberScreen(child: content),
    );
  }

  void _openStep(BuildContext context, CampaignStep step) {
    if (step.type == CampaignStepType.course) {
      Navigator.pushNamed(
        context,
        CourseDetailScreen.routeName,
        arguments: step.targetId,
      );
      return;
    }
    Navigator.pushNamed(
      context,
      MissionDetailScreen.routeName,
      arguments: step.targetId,
    );
  }
}
