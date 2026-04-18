import 'package:flutter/material.dart';

import '../../../core/state/hacksim_controller.dart';
import '../../challenges/presentation/daily_challenge_screen.dart';
import '../../courses/presentation/courses_screen.dart';
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
    ];

    final titles = ['HackSim', 'Cours', 'Missions', 'Progression', 'Profil'];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_index]),
        actions: [
          IconButton(
            tooltip: 'Défi quotidien',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => DailyChallengeScreen(controller: widget.controller),
                ),
              );
            },
            icon: const Icon(Icons.bolt_rounded),
          ),
        ],
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Accueil'),
          NavigationDestination(icon: Icon(Icons.menu_book_rounded), label: 'Cours'),
          NavigationDestination(icon: Icon(Icons.security_rounded), label: 'Missions'),
          NavigationDestination(icon: Icon(Icons.show_chart_rounded), label: 'Progression'),
          NavigationDestination(icon: Icon(Icons.person_rounded), label: 'Profil'),
        ],
      ),
    );
  }
}
