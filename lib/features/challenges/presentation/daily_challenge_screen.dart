import 'package:flutter/material.dart';

import '../../../core/state/hacksim_controller.dart';
import '../../../core/widgets/cyber_screen.dart';

class DailyChallengeScreen extends StatefulWidget {
  const DailyChallengeScreen({super.key, required this.controller, this.embedded = false});

  static const routeName = '/daily-challenge';

  final HackSimController controller;
  final bool embedded;

  @override
  State<DailyChallengeScreen> createState() => _DailyChallengeScreenState();
}

class _DailyChallengeScreenState extends State<DailyChallengeScreen> {
  int? _selected;
  bool _revealed = false;

  @override
  Widget build(BuildContext context) {
    final challenge = widget.controller.todaysChallenge;
    final challengeId = challenge.idForDate(widget.controller.today);
    final done = widget.controller.isDailyChallengeCompleted(challengeId);
    final isCorrect = _selected == challenge.correctOptionIndex;

    final content = ListView(
      children: [
        CyberCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Défi quotidien', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 6),
              Text(challenge.title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  Chip(label: Text(challenge.category)),
                  Chip(label: Text('${challenge.xpReward} XP')),
                  Chip(label: Text(done ? 'Déjà validé' : 'Disponible')), 
                ],
              ),
              const SizedBox(height: 12),
              Text(challenge.prompt),
            ],
          ),
        ),
        ...List.generate(challenge.options.length, (index) {
          final option = challenge.options[index];
          Color? color;
          if ((_revealed || done) && index == challenge.correctOptionIndex) {
            color = Colors.green.withValues(alpha: 0.25);
          } else if ((_revealed || done) && _selected == index && !isCorrect) {
            color = Colors.red.withValues(alpha: 0.25);
          }

          return Card(
            color: color,
            child: ListTile(
              title: Text(option),
              onTap: done || _revealed
                  ? null
                  : () {
                      setState(() {
                        _selected = index;
                        _revealed = true;
                      });
                    },
            ),
          );
        }),
        if (_revealed || done)
          CyberCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(done || isCorrect ? 'Bonne réponse.' : 'Réponse incorrecte.'),
                const SizedBox(height: 8),
                Text('Explication: ${challenge.explanation}'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: done
                      ? null
                      : isCorrect
                          ? () async {
                              await widget.controller.completeDailyChallenge();
                              if (!context.mounted) {
                                return;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('+${challenge.xpReward} XP défi quotidien !')),
                              );
                              setState(() {});
                            }
                          : null,
                  child: Text(done ? 'Défi déjà validé' : 'Valider le défi'),
                ),
              ],
            ),
          ),
      ],
    );

    if (widget.embedded) {
      return CyberScreen(child: content);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Défi Quotidien')),
      body: CyberScreen(child: content),
    );
  }
}
