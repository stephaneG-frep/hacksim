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
              'HackSim est une application éducative de cybersécurité. Tout le contenu est simulé et défensif pour apprendre sans risque réel. Aucun outil offensif ni fonctionnalité active sur des systèmes réels.',
        ),
        _GuideSection(
          title: '2. Commencer rapidement',
          body:
              'Depuis l\'accueil, ouvre un cours débutant, lis les sections, puis valide le quiz final pour gagner de l\'XP et débloquer la suite. Le niveau augmente tous les 200 XP.',
        ),
        _GuideSection(
          title: '3. Progression et déverrouillage',
          body:
              'Verrouillé = prérequis manquant (XP insuffisant ou quiz non validé). Déverrouillé = accessible. Validé = activité terminée avec attribution XP. Les cours validés débloquent des missions, qui débloquent des badges.',
        ),
        _GuideSection(
          title: '4. Missions et terminal interactif',
          body:
              'Certaines étapes de mission affichent un terminal simulé. Tu dois y taper la commande indiquée (exemple: "net-sim scan target-01") avant de pouvoir répondre au QCM. La commande est validée sans distinction majuscule/minuscule. Un indice est affiché sous le champ si tu bloques.',
        ),
        _GuideSection(
          title: '5. Campagnes guidées',
          body:
              'Les campagnes enchaînent cours et missions dans un ordre pédagogique. Chaque jalon validé fait progresser la barre de campagne. Un badge exclusif est débloqué à 100 % de complétion.',
        ),
        _GuideSection(
          title: '6. Défis quotidiens et streak',
          body:
              'Un défi pédagogique est proposé chaque jour. Réussir plusieurs jours d\'affilée augmente ton streak quotidien. Le streak se réinitialise si tu rates une journée complète. Le meilleur streak est conservé.',
        ),
        _GuideSection(
          title: '7. Badges et saison',
          body:
              'Les badges récompensent les jalons : XP cumulés, quiz validés, missions terminées, streaks consécutifs, campagnes complètes. La saison XP se remet à zéro chaque trimestre (hiver, printemps, été, automne).',
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
              a: 'Le quiz d\'un cours prérequis n\'a pas encore été validé, ou ton XP total est insuffisant pour les missions.',
            ),
            _FaqItem(
              q: 'Comment gagner de l\'XP rapidement ?',
              a: 'Valide les quiz de cours, réussis les missions (score ≥ 67 %) et complète le défi quotidien chaque jour.',
            ),
            _FaqItem(
              q: 'Le streak baisse quand ?',
              a: 'Si tu ne valides pas le défi quotidien pendant une journée complète. Le défi change à minuit.',
            ),
            _FaqItem(
              q: 'Comment fonctionne le terminal interactif ?',
              a: 'Dans certaines étapes de mission, tu dois taper une commande simulée dans le champ "\$". Appuie sur Entrée ou sur la flèche pour valider. Une fois correcte, le QCM se déverrouille.',
            ),
            _FaqItem(
              q: 'Puis-je ajouter du contenu sans mettre à jour l\'app ?',
              a: 'Oui, via les fichiers JSON dans assets/content/ (courses_extra.json, missions_extra.json…). Le contenu est chargé au démarrage et fusionné avec le contenu embarqué.',
            ),
            _FaqItem(
              q: 'HackSim contient-il des outils offensifs ?',
              a: 'Non. Tout est simulé (préfixe [SIM]) et conçu pour l\'apprentissage défensif uniquement.',
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
      ('MFA', 'Authentification multifacteur : plusieurs preuves d\'identité requises (mot de passe + code SMS, clé physique…).'),
      ('Phishing', 'Manipulation par email ou message pour voler des identifiants ou infecter un système.'),
      ('SIEM', 'Plateforme qui centralise et corrèle les logs sécurité pour détecter les incidents.'),
      ('Zero Trust', 'Modèle de sécurité "ne jamais faire confiance, toujours vérifier" : chaque accès est authentifié même depuis l\'intérieur du réseau.'),
      ('Microsegmentation', 'Division du réseau en zones isolées pour limiter les déplacements latéraux en cas de compromission.'),
      ('SQLi', 'Injection SQL : insertion de code malveillant dans une requête via un champ utilisateur non sanitisé.'),
      ('CSP', 'Content Security Policy : politique navigateur limitant les scripts et ressources exécutables sur une page.'),
      ('Incident response', 'Processus structuré de détection, confinement, éradication et récupération après un incident sécurité.'),
      ('Principe du moindre privilège', 'Donner à chaque utilisateur et service uniquement les droits strictement nécessaires à sa fonction.'),
      ('Streak', 'Nombre de jours consécutifs où le défi quotidien a été validé.'),
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
                    TextSpan(text: '${entry.$1} : ', style: const TextStyle(fontWeight: FontWeight.w700)),
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
