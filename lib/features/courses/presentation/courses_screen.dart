import 'package:flutter/material.dart';

import '../../../core/state/hacksim_controller.dart';
import '../../../core/widgets/cyber_screen.dart';
import '../domain/course_model.dart';
import 'course_detail_screen.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({
    super.key,
    required this.controller,
    this.embedded = false,
  });

  static const routeName = '/courses';

  final HackSimController controller;
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final grouped = {
      for (final level in CourseLevel.values)
        level: controller.courses.where((course) => course.level == level).toList(),
    };

    int order = 0;
    final content = ListView(
      children: [
        for (final level in CourseLevel.values) ...[
          Text(level.label, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...grouped[level]!.map((course) {
            final unlocked = controller.isCourseUnlocked(course);
            final validated = controller.isQuizValidated(course.id);
            order += 1;
            return AnimatedCyberCard(
              order: order,
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
          const SizedBox(height: 16),
        ],
      ],
    );

    if (embedded) {
      return CyberScreen(child: content);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Cours')),
      body: CyberScreen(child: content),
    );
  }
}
