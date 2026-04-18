import 'package:flutter/material.dart';

import '../../../core/state/hacksim_controller.dart';
import '../../../core/widgets/cyber_screen.dart';
import 'mission_detail_screen.dart';

class MissionsScreen extends StatelessWidget {
  const MissionsScreen({super.key, required this.controller});

  static const routeName = '/missions';

  final HackSimController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Missions')),
      body: CyberScreen(
        child: ListView.builder(
          itemCount: controller.missions.length,
          itemBuilder: (context, index) {
            final mission = controller.missions[index];
            final unlocked = controller.isMissionUnlocked(mission);
            final done = controller.isMissionCompleted(mission.id);

            return CyberCard(
              onTap: unlocked
                  ? () => Navigator.pushNamed(
                        context,
                        MissionDetailScreen.routeName,
                        arguments: mission.id,
                      )
                  : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        done ? Icons.shield_rounded : (unlocked ? Icons.play_circle_fill_rounded : Icons.lock_rounded),
                        color: done ? Colors.greenAccent : Colors.white70,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          mission.title,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(label: Text(mission.difficulty)),
                      Chip(label: Text(mission.category)),
                      Chip(label: Text('${mission.xpReward} XP')),
                      Chip(label: Text(unlocked ? 'Déverrouillée' : 'Verrouillée')),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
