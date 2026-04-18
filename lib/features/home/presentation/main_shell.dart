import 'package:flutter/material.dart';

import '../../../core/state/hacksim_controller.dart';
import '../../challenges/presentation/daily_challenge_screen.dart';
import '../../courses/presentation/courses_screen.dart';
import '../../help/presentation/user_guide_screen.dart';
import '../../missions/presentation/missions_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../progression/presentation/progression_screen.dart';
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
      ProgressionScreen(controller: widget.controller, embedded: true),
      ProfileScreen(controller: widget.controller, embedded: true),
      DailyChallengeScreen(controller: widget.controller, embedded: true),
      const UserGuideScreen(embedded: true),
    ];

    final titles = [
      'HackSim',
      'Cours',
      'Missions',
      'Progression',
      'Profil',
      'Défi Quotidien',
      'Mode d\'emploi',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_index]),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                title: Text(
                  widget.controller.pseudo,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text('Niveau ${widget.controller.level} • ${widget.controller.totalXp} XP'),
                leading: const CircleAvatar(child: Icon(Icons.security_rounded)),
              ),
              const Divider(),
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
                label: 'Progression',
                selected: _index == 3,
                onTap: () => _goTo(3),
              ),
              _DrawerItem(
                icon: Icons.person_rounded,
                label: 'Profil',
                selected: _index == 4,
                onTap: () => _goTo(4),
              ),
              _DrawerItem(
                icon: Icons.bolt_rounded,
                label: 'Défi quotidien',
                selected: _index == 5,
                onTap: () => _goTo(5),
              ),
              _DrawerItem(
                icon: Icons.help_center_rounded,
                label: 'Mode d\'emploi',
                selected: _index == 6,
                onTap: () => _goTo(6),
              ),
            ],
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
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
