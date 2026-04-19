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
          title: '4. Défis quotidiens et streak',
          body:
              'Un défi pédagogique est proposé chaque jour. Réussir plusieurs jours d’affilée augmente ton streak quotidien.',
        ),
        _GuideSection(
          title: '5. Interprétation des états',
          body:
              'Verrouillé = prérequis manquant. Déverrouillé = accessible. Validé = activité terminée avec attribution XP.',
        ),
        _FaqSection(),
        _LexiconSection(),
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

class _FaqSection extends StatelessWidget {
  const _FaqSection();

  @override
  Widget build(BuildContext context) {
    return CyberCard(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: const ExpansionTile(
          tilePadding: EdgeInsets.zero,
          title: Text('FAQ rapide'),
          childrenPadding: EdgeInsets.only(bottom: 8),
          children: [
            _FaqItem(
              q: 'Pourquoi un cours est verrouillé ?',
              a: 'Le quiz d’un cours prérequis n’a pas encore été validé.',
            ),
            _FaqItem(
              q: 'Comment gagner de l’XP rapidement ?',
              a: 'Valide les quiz, réussis les missions et complète le défi quotidien.',
            ),
            _FaqItem(
              q: 'Le streak baisse quand ?',
              a: 'Si tu ne valides pas le défi quotidien pendant une journée complète.',
            ),
            _FaqItem(
              q: 'HackSim contient-il des outils offensifs ?',
              a: 'Non. Tout est simulé et conçu pour l’apprentissage défensif.',
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  const _FaqItem({required this.q, required this.a});

  final String q;
  final String a;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Q: $q', style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text('R: $a'),
        ],
      ),
    );
  }
}

class _LexiconSection extends StatelessWidget {
  const _LexiconSection();

  @override
  Widget build(BuildContext context) {
    final entries = [
      ('MFA', 'Authentification multifacteur: plusieurs preuves d’identité.'),
      ('Phishing', 'Tentative de manipulation pour voler des infos sensibles.'),
      ('SIEM', 'Plateforme qui centralise et corrèle les logs sécurité.'),
      ('CSP', 'Politique navigateur limitant les scripts exécutables.'),
      ('Segmentation', 'Séparation réseau pour limiter les mouvements latéraux.'),
      ('Incident response', 'Processus de gestion et remédiation d’un incident.'),
    ];

    return CyberCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Lexique cyber', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(text: '${entry.$1}: ', style: const TextStyle(fontWeight: FontWeight.w700)),
                    TextSpan(text: entry.$2),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
