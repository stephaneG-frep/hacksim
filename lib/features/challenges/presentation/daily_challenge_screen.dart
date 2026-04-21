import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/hacksim_provider.dart';
import '../../../core/widgets/cyber_screen.dart';

class DailyChallengeScreen extends ConsumerStatefulWidget {
  const DailyChallengeScreen({super.key, this.embedded = false});

  static const routeName = '/daily-challenge';

  final bool embedded;

  @override
  ConsumerState<DailyChallengeScreen> createState() => _DailyChallengeScreenState();
}

class _DailyChallengeScreenState extends ConsumerState<DailyChallengeScreen> {
  int? _selected;
  bool _revealed = false;

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(hackSimControllerProvider);
    final challenge = controller.todaysChallenge;
    final challengeId = challenge.idForDate(controller.today);
    final done = controller.isDailyChallengeCompleted(challengeId);
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
              Text(
                'Aligné sur: ${challenge.learningFocus}',
                style: const TextStyle(color: Color(0xFF65FFBF)),
              ),
              const SizedBox(height: 8),
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
                              await ref.read(hackSimControllerProvider).completeDailyChallenge();
                              if (!context.mounted) return;
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
