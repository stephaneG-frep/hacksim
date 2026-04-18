import 'package:flutter/material.dart';

import '../../../core/state/hacksim_controller.dart';
import '../../../core/widgets/cyber_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.controller});

  static const routeName = '/profile';

  final HackSimController controller;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _pseudoController;

  @override
  void initState() {
    super.initState();
    _pseudoController = TextEditingController(text: widget.controller.pseudo);
  }

  @override
  void dispose() {
    _pseudoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: CyberScreen(
        child: ListView(
          children: [
            TextField(
              controller: _pseudoController,
              decoration: const InputDecoration(labelText: 'Pseudo'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                await controller.updatePseudo(_pseudoController.text);
                if (!context.mounted) {
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pseudo mis à jour.')));
              },
              child: const Text('Enregistrer'),
            ),
            const SizedBox(height: 16),
            CyberCard(
              child: ListTile(
                title: const Text('XP totale'),
                trailing: Text('${controller.totalXp} XP'),
              ),
            ),
            CyberCard(
              child: ListTile(
                title: const Text('Niveau'),
                trailing: Text('Niv. ${controller.level}'),
              ),
            ),
            CyberCard(
              child: ListTile(
                title: const Text('Cours validés'),
                trailing: Text('${controller.validatedQuizIds.length}'),
              ),
            ),
            CyberCard(
              child: ListTile(
                title: const Text('Missions terminées'),
                trailing: Text('${controller.completedMissionIds.length}'),
              ),
            ),
            CyberCard(
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
        ),
      ),
    );
  }
}
