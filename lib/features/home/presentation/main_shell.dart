import 'package:flutter/material.dart';

import '../../../core/state/hacksim_controller.dart';
import '../../campaigns/presentation/campaigns_screen.dart';
import '../../challenges/presentation/daily_challenge_screen.dart';
import '../../courses/presentation/courses_screen.dart';
import '../../help/presentation/user_guide_screen.dart';
import '../../missions/presentation/missions_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../progression/presentation/progression_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import 'home_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.controller});

  final HackSimController controller;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      HomeScreen(controller: widget.controller, embedded: true),
      CoursesScreen(controller: widget.controller, embedded: true),
      MissionsScreen(controller: widget.controller, embedded: true),
      CampaignsScreen(controller: widget.controller, embedded: true),
      ProgressionScreen(controller: widget.controller, embedded: true),
      ProfileScreen(controller: widget.controller, embedded: true),
      DailyChallengeScreen(controller: widget.controller, embedded: true),
      const UserGuideScreen(embedded: true),
      SettingsScreen(controller: widget.controller, embedded: true),
    ];

    final titles = [
      'HackSim',
      'Cours',
      'Missions',
      'Campagnes',
      'Progression',
      'Profil',
      'Défi Quotidien',
      'Mode d\'emploi',
      'Paramètres',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_index]),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0B141C), Color(0xFF153245)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 22,
                          child: Icon(Icons.security_rounded),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.controller.pseudo,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('Niveau ${widget.controller.level} • ${widget.controller.totalXp} XP'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _StatChip(label: '${widget.controller.currentDailyStreak}j streak'),
                        _StatChip(label: '${widget.controller.seasonXp} XP saison'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SafeArea(
                top: false,
                child: ListView(
                  children: [
                    _DrawerItem(
                      icon: Icons.home_rounded,
                      label: 'Accueil',
                      selected: _index == 0,
                      onTap: () => _goTo(0),
                    ),
                    _DrawerItem(
                      icon: Icons.menu_book_rounded,
                      label: 'Cours',
                      selected: _index == 1,
                      onTap: () => _goTo(1),
                    ),
                    _DrawerItem(
                      icon: Icons.security_rounded,
                      label: 'Missions',
                      selected: _index == 2,
                      onTap: () => _goTo(2),
                    ),
                    _DrawerItem(
                      icon: Icons.show_chart_rounded,
                      label: 'Campagnes',
                      selected: _index == 3,
                      onTap: () => _goTo(3),
                    ),
                    _DrawerItem(
                      icon: Icons.show_chart_rounded,
                      label: 'Progression',
                      selected: _index == 4,
                      onTap: () => _goTo(4),
                    ),
                    _DrawerItem(
                      icon: Icons.person_rounded,
                      label: 'Profil',
                      selected: _index == 5,
                      onTap: () => _goTo(5),
                    ),
                    _DrawerItem(
                      icon: Icons.bolt_rounded,
                      label: 'Défi quotidien',
                      selected: _index == 6,
                      onTap: () => _goTo(6),
                    ),
                    _DrawerItem(
                      icon: Icons.help_center_rounded,
                      label: 'Mode d\'emploi',
                      selected: _index == 7,
                      onTap: () => _goTo(7),
                    ),
                    _DrawerItem(
                      icon: Icons.settings_rounded,
                      label: 'Paramètres',
                      selected: _index == 8,
                      onTap: () => _goTo(8),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: AnimatedSwitcher(
        duration: widget.controller.animationsEnabled
            ? const Duration(milliseconds: 360)
            : Duration.zero,
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          if (!widget.controller.animationsEnabled) {
            return child;
          }
          final slide = Tween<Offset>(begin: const Offset(0.02, 0), end: Offset.zero)
              .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(position: slide, child: child),
          );
        },
        child: KeyedSubtree(
          key: ValueKey(_index),
          child: tabs[_index],
        ),
      ),
    );
  }

  void _goTo(int index) {
    Navigator.of(context).pop();
    setState(() => _index = index);
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      selected: selected,
      onTap: onTap,
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black.withValues(alpha: 0.25),
        border: Border.all(color: const Color(0xFF00E5A8).withValues(alpha: 0.4)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}
