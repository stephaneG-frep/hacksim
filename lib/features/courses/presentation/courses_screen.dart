import 'package:flutter/material.dart';

import '../../../core/state/hacksim_controller.dart';
import '../../../core/widgets/cyber_screen.dart';
import '../domain/course_model.dart';
import 'course_detail_screen.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({
    super.key,
    required this.controller,
    this.embedded = false,
  });

  static const routeName = '/courses';

  final HackSimController controller;
  final bool embedded;

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final TextEditingController _searchController = TextEditingController();
  CourseLevel? _levelFilter;
  bool _unlockedOnly = false;

  @override
  void initState() {
    super.initState();
    _unlockedOnly = widget.controller.showOnlyUnlockedDefault;
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();

    final filtered = widget.controller.courses.where((course) {
      final unlocked = widget.controller.isCourseUnlocked(course);
      if (_unlockedOnly && !unlocked) {
        return false;
      }
      if (_levelFilter != null && course.level != _levelFilter) {
        return false;
      }
      if (query.isEmpty) {
        return true;
      }
      return course.title.toLowerCase().contains(query) ||
          course.category.toLowerCase().contains(query) ||
          course.level.label.toLowerCase().contains(query);
    }).toList();

    final grouped = {
      for (final level in CourseLevel.values)
        level: filtered.where((course) => course.level == level).toList(),
    };

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
                  labelText: 'Rechercher un cours',
                  prefixIcon: Icon(Icons.search_rounded),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilterChip(
                    label: const Text('Déverrouillés'),
                    selected: _unlockedOnly,
                    onSelected: (v) => setState(() => _unlockedOnly = v),
                  ),
                  ...CourseLevel.values.map(
                    (level) => ChoiceChip(
                      label: Text(level.label),
                      selected: _levelFilter == level,
                      onSelected: (_) {
                        setState(() {
                          _levelFilter = _levelFilter == level ? null : level;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        for (final level in CourseLevel.values) ...[
          if (grouped[level]!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(level.label, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            ...grouped[level]!.map((course) {
              final unlocked = widget.controller.isCourseUnlocked(course);
              final validated = widget.controller.isQuizValidated(course.id);
              return AnimatedCyberCard(
                order: order++,
                onTap: unlocked
                    ? () => Navigator.pushNamed(
                          context,
                          CourseDetailScreen.routeName,
                          arguments: course.id,
                        )
                    : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          validated
                              ? Icons.verified_rounded
                              : (unlocked ? Icons.lock_open_rounded : Icons.lock_rounded),
                          color: validated ? Colors.greenAccent : Colors.white70,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            course.title,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Chip(label: Text(course.level.label)),
                        Chip(label: Text(course.category)),
                        Chip(label: Text('${course.durationMinutes} min')),
                        Chip(label: Text('${course.xpReward} XP')),
                        Chip(label: Text(unlocked ? 'Déverrouillé' : 'Verrouillé')),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
        if (filtered.isEmpty)
          AnimatedCyberCard(
            order: order++,
            child: const Text('Aucun cours ne correspond aux filtres actuels.'),
          ),
      ],
    );

    if (widget.embedded) {
      return CyberScreen(child: content);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Cours')),
      body: CyberScreen(child: content),
    );
  }
}
