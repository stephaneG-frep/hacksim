import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/hacksim_provider.dart';
import '../../../core/widgets/cyber_screen.dart';

class MissionDetailScreen extends ConsumerStatefulWidget {
  const MissionDetailScreen({super.key, required this.missionId});

  static const routeName = '/mission-detail';

  final String missionId;

  @override
  ConsumerState<MissionDetailScreen> createState() => _MissionDetailScreenState();
}

class _MissionDetailScreenState extends ConsumerState<MissionDetailScreen> {
  int _stepIndex = 0;
  int _score = 0;
  int? _selected;
  bool _revealed = false;
  bool _finished = false;

  @override
  Widget build(BuildContext context) {
    final mission = ref.read(hackSimControllerProvider).missionById(widget.missionId);

    if (_finished) {
      final ratio = _score / mission.steps.length;
      final passed = ratio >= 0.67;
      final percent = (ratio * 100).round();

      return Scaffold(
        appBar: AppBar(title: const Text('Fin de mission')),
        body: CyberScreen(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CyberCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(mission.title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text('Score: $percent% ($_score/${mission.steps.length})'),
                    const SizedBox(height: 10),
                    Text(
                      passed
                          ? 'Mission réussie. XP gagnée: ${mission.xpReward}.'
                          : 'Mission à renforcer. Rejoue pour valider les réflexes défensifs.',
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton(
                      onPressed: passed
                          ? () async {
                              await ref.read(hackSimControllerProvider).completeMission(
                                    missionId: mission.id,
                                    xpReward: mission.xpReward,
                                  );
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('+${mission.xpReward} XP ajoutés !')),
                              );
                              Navigator.pop(context);
                            }
                          : null,
                      child: const Text('Valider la mission'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    final step = mission.steps[_stepIndex];
    final isCorrect = _selected == step.correctOptionIndex;

    return Scaffold(
      appBar: AppBar(title: Text(mission.title)),
      body: CyberScreen(
        child: ListView(
          children: [
            CyberCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Scénario', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(mission.scenario),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text('Étape ${_stepIndex + 1}/${mission.steps.length}',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(step.title),
            const SizedBox(height: 12),
            if (step.terminalSnippet != null) TerminalPanel(text: step.terminalSnippet!),
            Text(step.prompt),
            const SizedBox(height: 10),
            ...List.generate(step.options.length, (optionIndex) {
              final option = step.options[optionIndex];
              Color? color;
              if (_revealed && optionIndex == step.correctOptionIndex) {
                color = Colors.green.withValues(alpha: 0.25);
              } else if (_revealed && _selected == optionIndex && !isCorrect) {
                color = Colors.red.withValues(alpha: 0.25);
              }
              return Card(
                color: color,
                child: ListTile(
                  title: Text(option),
                  onTap: _revealed
                      ? null
                      : () {
                          setState(() {
                            final pickedCorrect = optionIndex == step.correctOptionIndex;
                            _selected = optionIndex;
                            _revealed = true;
                            if (pickedCorrect) _score += 1;
                          });
                        },
                ),
              );
            }),
            if (_revealed) ...[
              const SizedBox(height: 8),
              Text(isCorrect ? 'Bonne décision.' : 'Décision à corriger.'),
              const SizedBox(height: 6),
              Text('Explication: ${step.explanation}'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  if (_stepIndex == mission.steps.length - 1) {
                    setState(() => _finished = true);
                  } else {
                    setState(() {
                      _stepIndex += 1;
                      _selected = null;
                      _revealed = false;
                    });
                  }
                },
                child: Text(_stepIndex == mission.steps.length - 1 ? 'Voir le score final' : 'Étape suivante'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
