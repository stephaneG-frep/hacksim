import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/hacksim_provider.dart';
import '../../../core/widgets/cyber_screen.dart';
import 'mission_detail_screen.dart';

class MissionsScreen extends ConsumerStatefulWidget {
  const MissionsScreen({super.key, this.embedded = false});

  static const routeName = '/missions';

  final bool embedded;

  @override
  ConsumerState<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends ConsumerState<MissionsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _difficultyFilter;
  bool _unlockedOnly = false;

  @override
  void initState() {
    super.initState();
    _unlockedOnly = ref.read(hackSimControllerProvider).showOnlyUnlockedDefault;
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(hackSimControllerProvider);
    final query = _searchController.text.trim().toLowerCase();
    final difficulties = controller.missions.map((m) => m.difficulty).toSet().toList()..sort();

    final filtered = controller.missions.where((mission) {
      final unlocked = controller.isMissionUnlocked(mission);
      if (_unlockedOnly && !unlocked) return false;
      if (_difficultyFilter != null && mission.difficulty != _difficultyFilter) return false;
      if (query.isEmpty) return true;
      return mission.title.toLowerCase().contains(query) ||
          mission.category.toLowerCase().contains(query) ||
          mission.difficulty.toLowerCase().contains(query);
    }).toList();

    int order = 0;
    final content = ListView(
      children: [
        AnimatedCyberCard(
          order: order++,
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Rechercher une mission',
                  prefixIcon: Icon(Icons.search_rounded),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilterChip(
                    label: const Text('Déverrouillées'),
                    selected: _unlockedOnly,
                    onSelected: (v) => setState(() => _unlockedOnly = v),
                  ),
                  ...difficulties.map(
                    (difficulty) => ChoiceChip(
                      label: Text(difficulty),
                      selected: _difficultyFilter == difficulty,
                      onSelected: (_) {
                        setState(() {
                          _difficultyFilter = _difficultyFilter == difficulty ? null : difficulty;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        ...filtered.asMap().entries.map((entry) {
          final mission = entry.value;
          final unlocked = controller.isMissionUnlocked(mission);
          final done = controller.isMissionCompleted(mission.id);
          return AnimatedCyberCard(
            order: order++,
            onTap: unlocked
                ? () => Navigator.pushNamed(context, MissionDetailScreen.routeName, arguments: mission.id)
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
        }),
        if (filtered.isEmpty)
          AnimatedCyberCard(
            order: order++,
            child: const Text('Aucune mission ne correspond aux filtres actuels.'),
          ),
      ],
    );

    if (widget.embedded) {
      return CyberScreen(child: content);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Missions')),
      body: CyberScreen(child: content),
    );
  }
}
