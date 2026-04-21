import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/hacksim_provider.dart';
import '../../../core/widgets/cyber_screen.dart';
import '../../challenges/presentation/daily_challenge_screen.dart';
import '../../courses/presentation/courses_screen.dart';
import '../../missions/presentation/missions_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../progression/presentation/progression_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(hackSimControllerProvider);
    final challenge = controller.todaysChallenge;
    final challengeDone = controller.isDailyChallengeCompleted(
      challenge.idForDate(controller.today),
    );

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnimatedCyberCard(
          order: 0,
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
              const SizedBox(height: 8),
              Text('${controller.seasonLabel} • ${controller.seasonXp} XP saison'),
              const SizedBox(height: 12),
              LinearProgressIndicator(value: controller.globalProgress),
            ],
          ),
        ),
        AnimatedCyberCard(
          order: 1,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const DailyChallengeScreen(),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.bolt_rounded, color: Color(0xFFFFC857)),
                  SizedBox(width: 8),
                  Text('Défi Quotidien', style: TextStyle(fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 8),
              Text(challenge.title),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  Chip(label: Text(challenge.category)),
                  Chip(label: Text('${challenge.xpReward} XP')),
                  Chip(label: Text(challengeDone ? 'Validé' : 'À faire')),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            final rawWidth = (constraints.maxWidth - 10) / 2;
            final tileWidth = math.max(120.0, rawWidth);
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _QuickAction(
                  width: tileWidth,
                  icon: Icons.menu_book_rounded,
                  label: 'Cours',
                  onTap: () => Navigator.pushNamed(context, CoursesScreen.routeName),
                ),
                _QuickAction(
                  width: tileWidth,
                  icon: Icons.security_rounded,
                  label: 'Missions',
                  onTap: () => Navigator.pushNamed(context, MissionsScreen.routeName),
                ),
                _QuickAction(
                  width: tileWidth,
                  icon: Icons.show_chart_rounded,
                  label: 'Progression',
                  onTap: () => Navigator.pushNamed(context, ProgressionScreen.routeName),
                ),
                _QuickAction(
                  width: tileWidth,
                  icon: Icons.person_rounded,
                  label: 'Profil',
                  onTap: () => Navigator.pushNamed(context, ProfileScreen.routeName),
                ),
              ],
            );
          },
        ),
        if (!embedded) ...[
          const SizedBox(height: 12),
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
      ],
    );

    if (embedded) {
      return CyberScreen(child: SingleChildScrollView(child: content));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('HackSim')),
      body: CyberScreen(child: SingleChildScrollView(child: content)),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.width, required this.icon, required this.label, required this.onTap});

  final double width;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton.icon(onPressed: onTap, icon: Icon(icon), label: Text(label)),
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
          "Aucune fonctionnalité offensive réelle n'est proposée.",
        ),
      ),
    );
  }
}
