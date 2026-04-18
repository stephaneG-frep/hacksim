import 'package:flutter/material.dart';

import '../../../core/state/hacksim_controller.dart';
import '../../../core/widgets/cyber_screen.dart';
import '../../courses/presentation/courses_screen.dart';
import '../../missions/presentation/missions_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../progression/presentation/progression_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.controller});

  final HackSimController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HackSim')),
      body: CyberScreen(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CyberCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bienvenue, ${controller.pseudo}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: const Color(0xFF65FFBF),
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text('Niveau ${controller.level} • ${controller.totalXp} XP'),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(value: controller.globalProgress),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _NavButton(
              label: 'Cours',
              icon: Icons.menu_book_rounded,
              onTap: () => Navigator.pushNamed(context, CoursesScreen.routeName),
            ),
            _NavButton(
              label: 'Missions',
              icon: Icons.security_rounded,
              onTap: () => Navigator.pushNamed(context, MissionsScreen.routeName),
            ),
            _NavButton(
              label: 'Progression',
              icon: Icons.show_chart_rounded,
              onTap: () => Navigator.pushNamed(context, ProgressionScreen.routeName),
            ),
            _NavButton(
              label: 'Profil',
              icon: Icons.person_rounded,
              onTap: () => Navigator.pushNamed(context, ProfileScreen.routeName),
            ),
            _NavButton(
              label: 'À propos',
              icon: Icons.info_outline_rounded,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const _AboutScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.label, required this.icon, required this.onTap});

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Align(
          alignment: Alignment.centerLeft,
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}

class _AboutScreen extends StatelessWidget {
  const _AboutScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('À propos')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'HackSim est une application éducative de cybersécurité. '
          'Tous les scénarios sont simulés et conçus pour apprendre des pratiques défensives.\n\n'
          'Aucune fonctionnalité offensive réelle n’est proposée.',
        ),
      ),
    );
  }
}
