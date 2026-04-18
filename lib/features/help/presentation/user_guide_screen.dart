import 'package:flutter/material.dart';

import '../../../core/widgets/cyber_screen.dart';

class UserGuideScreen extends StatelessWidget {
  const UserGuideScreen({super.key, this.embedded = false});

  static const routeName = '/user-guide';

  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final content = ListView(
      children: const [
        _GuideSection(
          title: '1. Objectif de HackSim',
          body:
              'HackSim est une application éducative de cybersécurité. Tout le contenu est simulé et défensif pour apprendre sans risque.',
        ),
        _GuideSection(
          title: '2. Commencer rapidement',
          body:
              'Depuis l’accueil, ouvre un cours débutant, lis les sections, puis valide le quiz final pour gagner de l’XP et débloquer la suite.',
        ),
        _GuideSection(
          title: '3. Progression',
          body:
              'Les cours validés débloquent des missions. Les missions réussies augmentent ton niveau et permettent d’obtenir des badges.',
        ),
        _GuideSection(
          title: '4. Défis quotidiens',
          body:
              'Chaque jour, un défi pédagogique est disponible. Une bonne réponse ajoute de l’XP globale et de l’XP de saison.',
        ),
        _GuideSection(
          title: '5. Interprétation des écrans',
          body:
              'Verrouillé = prérequis manquant. Déverrouillé = accessible. Validé = quiz ou mission déjà terminée avec attribution XP.',
        ),
        _GuideSection(
          title: '6. Bonnes pratiques',
          body:
              'Prends le temps de lire les explications pédagogiques. Elles expliquent le raisonnement défensif attendu dans un contexte réel.',
        ),
      ],
    );

    if (embedded) {
      return CyberScreen(child: content);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Mode d\'emploi')),
      body: CyberScreen(child: content),
    );
  }
}

class _GuideSection extends StatelessWidget {
  const _GuideSection({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return CyberCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(body),
        ],
      ),
    );
  }
}
