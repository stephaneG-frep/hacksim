import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/hacksim_provider.dart';
import '../../../core/widgets/cyber_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key, this.embedded = false});

  static const routeName = '/profile';

  final bool embedded;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late final TextEditingController _pseudoController;

  @override
  void initState() {
    super.initState();
    _pseudoController = TextEditingController(
      text: ref.read(hackSimControllerProvider).pseudo,
    );
  }

  @override
  void dispose() {
    _pseudoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(hackSimControllerProvider);

    final content = ListView(
      children: [
        TextField(
          controller: _pseudoController,
          decoration: const InputDecoration(labelText: 'Pseudo'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            await ref.read(hackSimControllerProvider).updatePseudo(_pseudoController.text);
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pseudo mis à jour.')));
          },
          child: const Text('Enregistrer'),
        ),
        const SizedBox(height: 16),
        AnimatedCyberCard(
          order: 0,
          child: ListTile(title: const Text('XP totale'), trailing: Text('${controller.totalXp} XP')),
        ),
        AnimatedCyberCard(
          order: 1,
          child: ListTile(
            title: const Text('XP de saison'),
            subtitle: Text(controller.seasonLabel),
            trailing: Text('${controller.seasonXp} XP'),
          ),
        ),
        AnimatedCyberCard(
          order: 2,
          child: ListTile(title: const Text('Niveau'), trailing: Text('Niv. ${controller.level}')),
        ),
        AnimatedCyberCard(
          order: 3,
          child: ListTile(
            title: const Text('Cours validés'),
            trailing: Text('${controller.validatedQuizIds.length}'),
          ),
        ),
        AnimatedCyberCard(
          order: 4,
          child: ListTile(
            title: const Text('Missions terminées'),
            trailing: Text('${controller.completedMissionIds.length}'),
          ),
        ),
        AnimatedCyberCard(
          order: 5,
          child: ListTile(
            title: const Text('Défis quotidiens validés'),
            trailing: Text('${controller.completedDailyChallengesCount}'),
          ),
        ),
        AnimatedCyberCard(
          order: 6,
          child: ListTile(
            title: const Text('Streak quotidien'),
            subtitle: Text('Best: ${controller.bestDailyStreak} jours'),
            trailing: Text('${controller.currentDailyStreak} j'),
          ),
        ),
        AnimatedCyberCard(
          order: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Badges', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              if (controller.badges.isEmpty)
                const Text('Aucun badge débloqué.')
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

    if (widget.embedded) {
      return CyberScreen(child: content);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: CyberScreen(child: content),
    );
  }
}
