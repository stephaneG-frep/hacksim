import 'package:flutter/material.dart';

import '../../../core/state/hacksim_controller.dart';
import '../../../core/widgets/cyber_screen.dart';

class ProgressionScreen extends StatelessWidget {
  const ProgressionScreen({super.key, required this.controller});

  static const routeName = '/progression';

  final HackSimController controller;

  @override
  Widget build(BuildContext context) {
    final totalCourses = controller.courses.length;
    final totalMissions = controller.missions.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Progression')),
      body: CyberScreen(
        child: ListView(
          children: [
            CyberCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Progression globale', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(value: controller.globalProgress),
                  const SizedBox(height: 8),
                  Text('${(controller.globalProgress * 100).round()}% complété'),
                ],
              ),
            ),
            CyberCard(
              child: ListTile(
                title: const Text('Cours terminés'),
                trailing: Text('${controller.validatedQuizIds.length}/$totalCourses'),
              ),
            ),
            CyberCard(
              child: ListTile(
                title: const Text('Missions réussies'),
                trailing: Text('${controller.completedMissionIds.length}/$totalMissions'),
              ),
            ),
            CyberCard(
              child: ListTile(
                title: const Text('Niveau utilisateur'),
                trailing: Text('Niv. ${controller.level}'),
              ),
            ),
            CyberCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Badges', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  if (controller.badges.isEmpty)
                    const Text('Aucun badge débloqué pour le moment.')
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: controller.badges.map((badge) => Chip(label: Text(badge))).toList(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
