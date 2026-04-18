import 'package:flutter/material.dart';

import '../../../core/state/hacksim_controller.dart';
import '../../../core/widgets/cyber_screen.dart';

class CourseQuizScreen extends StatefulWidget {
  const CourseQuizScreen({super.key, required this.controller, required this.courseId});

  static const routeName = '/course-quiz';

  final HackSimController controller;
  final String courseId;

  @override
  State<CourseQuizScreen> createState() => _CourseQuizScreenState();
}

class _CourseQuizScreenState extends State<CourseQuizScreen> {
  int _index = 0;
  int _correctAnswers = 0;
  int? _selected;
  bool _revealed = false;
  bool _finished = false;

  @override
  Widget build(BuildContext context) {
    final course = widget.controller.courseById(widget.courseId);

    if (_finished) {
      final score = (_correctAnswers / course.quiz.length * 100).round();
      final passed = score >= 70;
      return Scaffold(
        appBar: AppBar(title: const Text('Résultat Quiz')),
        body: CyberScreen(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CyberCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Score final: $score%', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Text(passed
                        ? 'Quiz validé. Tu peux récupérer ${course.xpReward} XP.'
                        : 'Quiz non validé. Reprends les leçons et retente.'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: passed
                          ? () async {
                              await widget.controller.validateQuiz(courseId: course.id, xpReward: course.xpReward);
                              if (!context.mounted) {
                                return;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('+${course.xpReward} XP ajoutés !')),
                              );
                              Navigator.pop(context);
                            }
                          : null,
                      child: const Text('Valider le quiz'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    final question = course.quiz[_index];
    final isCorrect = _selected == question.correctOptionIndex;

    return Scaffold(
      appBar: AppBar(title: Text('Quiz • ${course.title}')),
      body: CyberScreen(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Question ${_index + 1}/${course.quiz.length}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(question.prompt),
            const SizedBox(height: 12),
            ...List.generate(question.options.length, (optionIndex) {
              final option = question.options[optionIndex];
              final selected = _selected == optionIndex;
              Color? tileColor;
              if (_revealed && optionIndex == question.correctOptionIndex) {
                tileColor = Colors.green.withValues(alpha: 0.25);
              } else if (_revealed && selected && !isCorrect) {
                tileColor = Colors.red.withValues(alpha: 0.25);
              }
              return Card(
                color: tileColor,
                child: ListTile(
                  onTap: _revealed
                      ? null
                      : () {
                          setState(() {
                            _selected = optionIndex;
                            _revealed = true;
                            if (_selected == question.correctOptionIndex) {
                              _correctAnswers += 1;
                            }
                          });
                        },
                  title: Text(option),
                ),
              );
            }),
            if (_revealed) ...[
              const SizedBox(height: 8),
              Text(isCorrect ? 'Bonne réponse.' : 'Réponse incorrecte.'),
              const SizedBox(height: 6),
              Text('Explication: ${question.explanation}'),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  if (_index == course.quiz.length - 1) {
                    setState(() => _finished = true);
                  } else {
                    setState(() {
                      _index += 1;
                      _selected = null;
                      _revealed = false;
                    });
                  }
                },
                child: Text(_index == course.quiz.length - 1 ? 'Terminer' : 'Question suivante'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
