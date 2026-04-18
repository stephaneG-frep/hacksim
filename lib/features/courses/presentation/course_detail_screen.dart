import 'package:flutter/material.dart';

import '../../../core/state/hacksim_controller.dart';
import '../../../core/widgets/cyber_screen.dart';
import 'course_quiz_screen.dart';

class CourseDetailScreen extends StatelessWidget {
  const CourseDetailScreen({super.key, required this.controller, required this.courseId});

  static const routeName = '/course-detail';

  final HackSimController controller;
  final String courseId;

  @override
  Widget build(BuildContext context) {
    final course = controller.courseById(courseId);

    return Scaffold(
      appBar: AppBar(title: Text(course.title)),
      body: CyberScreen(
        child: ListView(
          children: [
            CyberCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.description),
                  const SizedBox(height: 12),
                  Text('Objectifs', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  ...course.objectives.map((goal) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text('• $goal'),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text('Leçons', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...course.lessons.map(
              (section) => CyberCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(section.title, style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 6),
                    Text(section.content),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                controller.markCourseStarted(course.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cours marqué comme démarré.')),
                );
              },
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Commencer'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, CourseQuizScreen.routeName, arguments: course.id),
              icon: const Icon(Icons.quiz_rounded),
              label: const Text('Quiz final'),
            ),
          ],
        ),
      ),
    );
  }
}
