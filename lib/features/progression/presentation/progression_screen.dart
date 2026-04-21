import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/hacksim_provider.dart';
import '../../../core/widgets/cyber_screen.dart';

class ProgressionScreen extends ConsumerWidget {
  const ProgressionScreen({super.key, this.embedded = false});

  static const routeName = '/progression';

  final bool embedded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(hackSimControllerProvider);
    final totalCourses = controller.courses.length;
    final totalMissions = controller.missions.length;

    final content = ListView(
      children: [
        AnimatedCyberCard(
          order: 0,
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
        AnimatedCyberCard(
          order: 1,
          child: ListTile(
            title: const Text('Cours terminés'),
            trailing: Text('${controller.validatedQuizIds.length}/$totalCourses'),
          ),
        ),
        AnimatedCyberCard(
          order: 2,
          child: ListTile(
            title: const Text('Missions réussies'),
            trailing: Text('${controller.completedMissionIds.length}/$totalMissions'),
          ),
        ),
        AnimatedCyberCard(
          order: 3,
          child: ListTile(
            title: const Text('Défis quotidiens validés'),
            trailing: Text('${controller.completedDailyChallengesCount}'),
          ),
        ),
        AnimatedCyberCard(
          order: 4,
          child: ListTile(
            title: const Text('Streak actuel'),
            subtitle: const Text('Jours consécutifs de défis validés'),
            trailing: Text('${controller.currentDailyStreak} j'),
          ),
        ),
        AnimatedCyberCard(
          order: 5,
          child: ListTile(
            title: const Text('Meilleur streak'),
            trailing: Text('${controller.bestDailyStreak} j'),
          ),
        ),
        AnimatedCyberCard(
          order: 6,
          child: ListTile(
            title: Text(controller.seasonLabel),
            subtitle: const Text('Progression de saison'),
            trailing: Text('${controller.seasonXp} XP'),
          ),
        ),
        AnimatedCyberCard(
          order: 7,
          child: ListTile(
            title: const Text('Niveau utilisateur'),
            trailing: Text('Niv. ${controller.level}'),
          ),
        ),
        AnimatedCyberCard(
          order: 8,
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
    );

    if (embedded) {
      return CyberScreen(child: content);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Progression')),
      body: CyberScreen(child: content),
    );
  }
}
