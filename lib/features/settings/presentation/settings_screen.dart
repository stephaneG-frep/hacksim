import 'package:flutter/material.dart';

import '../../../core/state/hacksim_controller.dart';
import '../../../core/widgets/cyber_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.controller, this.embedded = false});

  static const routeName = '/settings';

  final HackSimController controller;
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final content = ListView(
      children: [
        AnimatedCyberCard(
          order: 0,
          child: SwitchListTile(
            value: controller.animationsEnabled,
            onChanged: (v) => controller.setAnimationsEnabled(v),
            title: const Text('Animations UI'),
            subtitle: const Text('Activer les transitions et animations visuelles'),
          ),
        ),
        AnimatedCyberCard(
          order: 1,
          child: SwitchListTile(
            value: controller.soundEnabled,
            onChanged: (v) => controller.setSoundEnabled(v),
            title: const Text('Feedback sonore (préférence)'),
            subtitle: const Text('Prépare les futurs sons de validation et alertes'),
          ),
        ),
        AnimatedCyberCard(
          order: 2,
          child: SwitchListTile(
            value: controller.showOnlyUnlockedDefault,
            onChanged: (v) => controller.setShowOnlyUnlockedDefault(v),
            title: const Text('Filtrer sur “déverrouillé” par défaut'),
            subtitle: const Text('Appliqué aux listes cours et missions'),
          ),
        ),
        AnimatedCyberCard(
          order: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Maintenance', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Réinitialiser la progression ?'),
                      content: const Text(
                        'Cette action supprime la progression locale (XP, badges, quiz et missions validés).',
                      ),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
                        ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Réinitialiser')),
                      ],
                    ),
                  );
                  if (confirmed != true) {
                    return;
                  }
                  await controller.resetProgress();
                  if (!context.mounted) {
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Progression réinitialisée.')),
                  );
                },
                icon: const Icon(Icons.restart_alt_rounded),
                label: const Text('Réinitialiser progression'),
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
      appBar: AppBar(title: const Text('Paramètres')),
      body: CyberScreen(child: content),
    );
  }
}
