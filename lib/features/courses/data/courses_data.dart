import '../domain/course_model.dart';

CourseModel _course({
  required String id,
  required String title,
  required CourseLevel level,
  required String category,
  required int duration,
  required int xp,
  required String description,
  required List<String> objectives,
  required List<LessonSection> lessons,
  required List<CourseQuizQuestion> quiz,
  List<String> prerequisites = const [],
}) {
  return CourseModel(
    id: id,
    title: title,
    level: level,
    category: category,
    durationMinutes: duration,
    xpReward: xp,
    description: description,
    objectives: objectives,
    lessons: lessons,
    quiz: quiz,
    prerequisites: prerequisites,
  );
}

List<LessonSection> _lessons(String focus) {
  return [
    LessonSection(
      title: 'Concepts essentiels',
      content:
          'Cette section introduit $focus avec des exemples du quotidien. On distingue menace, risque, impact et mesures de protection.',
    ),
    LessonSection(
      title: 'Analyse guidée',
      content:
          'Tu observes une situation simulée, puis tu identifies les signaux faibles et les bonnes décisions de défense étape par étape.',
    ),
    LessonSection(
      title: 'Checklist pratique',
      content:
          'Résumé actionnable: habitudes sûres, pièges fréquents, et règles simples pour renforcer la sécurité sans outils offensifs.',
    ),
    LessonSection(
      title: 'Mini étude de cas',
      content:
          'Cas simulé autour de $focus: tu appliques une logique défensive, puis tu compares ta décision à une correction expliquée.',
    ),
  ];
}

List<CourseQuizQuestion> _quiz({
  required String topic,
  required String secureAction,
  required String commonMistake,
}) {
  return [
    CourseQuizQuestion(
      prompt: 'Quel est le meilleur objectif quand on traite $topic ?',
      options: const [
        'Maximiser la rapidité au détriment des vérifications',
        'Réduire le risque par des pratiques défensives mesurées',
        'Ignorer les procédures pour gagner du temps',
        'Tester en production sans validation',
      ],
      correctOptionIndex: 1,
      explanation:
          'La cybersécurité pédagogique vise la réduction du risque et la résilience, pas la vitesse brute ni les actions imprudentes.',
    ),
    CourseQuizQuestion(
      prompt: 'Quelle action est recommandée en priorité ?',
      options: [secureAction, commonMistake, 'Ne rien documenter', 'Partager les accès entre collègues'],
      correctOptionIndex: 0,
      explanation:
          'Une bonne défense repose sur des actions préventives claires, traçables et répétables.',
    ),
    CourseQuizQuestion(
      prompt: 'Pourquoi la sensibilisation est-elle importante ?',
      options: const [
        'Parce que les attaques réelles n’existent pas',
        'Parce que la plupart des incidents commencent par une erreur humaine évitable',
        'Parce que les mots de passe ne servent plus',
        'Parce que les logs remplacent les humains',
      ],
      correctOptionIndex: 1,
      explanation:
          'La majorité des incidents impliquent de la manipulation sociale ou des erreurs d’hygiène numérique.',
    ),
    CourseQuizQuestion(
      prompt: 'Quel réflexe améliore le plus la résilience équipe ?',
      options: const [
        'Documenter incidents et retours d’expérience',
        'Garder les incidents secrets pour éviter les questions',
        'Ignorer les alertes faibles',
        'Confondre vitesse et sécurité',
      ],
      correctOptionIndex: 0,
      explanation:
          'Le retour d’expérience partagé améliore durablement les procédures et réduit la répétition des erreurs.',
    ),
  ];
}

final List<CourseModel> coursesData = [
  _course(
    id: 'intro-cyber',
    title: 'Introduction à la cybersécurité',
    level: CourseLevel.beginner,
    category: 'Fondamentaux',
    duration: 20,
    xp: 50,
    description: 'Comprendre les bases: menaces, actifs, impacts et principes de défense.',
    objectives: const [
      'Identifier les types de menaces courants',
      'Comprendre confidentialité, intégrité, disponibilité',
      'Adopter un réflexe de défense proactive',
    ],
    lessons: _lessons('les fondamentaux de la cybersécurité'),
    quiz: _quiz(
      topic: 'les fondamentaux cyber',
      secureAction: 'Cartographier les risques et prioriser les protections',
      commonMistake: 'Tout traiter comme non prioritaire',
    ),
  ),
  _course(
    id: 'password-auth',
    title: 'Mots de passe et authentification',
    level: CourseLevel.beginner,
    category: 'Hygiène numérique',
    duration: 18,
    xp: 55,
    description: 'Créer des accès robustes avec MFA et gestionnaire de mots de passe.',
    objectives: const [
      'Construire une politique de mots de passe solide',
      'Activer l’authentification multifacteur',
      'Éviter réutilisation et stockage risqué',
    ],
    lessons: _lessons('les mots de passe et la gestion des identités'),
    quiz: _quiz(
      topic: 'l’authentification',
      secureAction: 'Activer MFA sur les comptes sensibles',
      commonMistake: 'Réutiliser le même mot de passe partout',
    ),
    prerequisites: const ['intro-cyber'],
  ),
  _course(
    id: 'phishing',
    title: 'Phishing et emails frauduleux',
    level: CourseLevel.beginner,
    category: 'Ingénierie sociale',
    duration: 22,
    xp: 60,
    description: 'Détecter les tentatives de phishing et appliquer les bons réflexes.',
    objectives: const [
      'Repérer les signaux d’alerte d’un email malveillant',
      'Valider un expéditeur et un lien',
      'Appliquer un protocole de signalement',
    ],
    lessons: _lessons('la détection du phishing'),
    quiz: _quiz(
      topic: 'les emails suspects',
      secureAction: 'Vérifier l’adresse réelle et le domaine du lien',
      commonMistake: 'Cliquer rapidement sur la pièce jointe',
    ),
    prerequisites: const ['password-auth'],
  ),
  _course(
    id: 'malware-hygiene',
    title: 'Malware et bonnes pratiques',
    level: CourseLevel.beginner,
    category: 'Protection poste',
    duration: 24,
    xp: 70,
    description: 'Comprendre les familles de malware et renforcer la protection locale.',
    objectives: const [
      'Différencier virus, ransomware et spyware',
      'Mettre à jour système et applications',
      'Isoler et signaler un poste suspect',
    ],
    lessons: _lessons('la prévention des malwares'),
    quiz: _quiz(
      topic: 'les malwares',
      secureAction: 'Maintenir les correctifs et sauvegardes régulières',
      commonMistake: 'Désactiver les alertes de sécurité',
    ),
    prerequisites: const ['phishing'],
  ),
  _course(
    id: 'network-basics',
    title: 'Bases réseau',
    level: CourseLevel.intermediate,
    category: 'Réseaux',
    duration: 25,
    xp: 75,
    description: 'Lire un réseau comme un défenseur: couches, flux, segmentation.',
    objectives: const [
      'Comprendre IP, DNS, TCP/UDP',
      'Suivre un flux de communication',
      'Isoler les segments critiques',
    ],
    lessons: _lessons('les fondamentaux réseau pour la défense'),
    quiz: _quiz(
      topic: 'les flux réseau',
      secureAction: 'Segmenter les ressources critiques',
      commonMistake: 'Exposer tous les services sur le même segment',
    ),
    prerequisites: const ['malware-hygiene'],
  ),
  _course(
    id: 'ports-services',
    title: 'Ports et services',
    level: CourseLevel.intermediate,
    category: 'Réseaux',
    duration: 26,
    xp: 80,
    description: 'Identifier les services exposés et réduire la surface d’attaque.',
    objectives: const [
      'Associer ports communs et protocoles',
      'Comprendre principe de moindre exposition',
      'Documenter les services autorisés',
    ],
    lessons: _lessons('les ports et services en environnement sécurisé'),
    quiz: _quiz(
      topic: 'les ports réseau',
      secureAction: 'Fermer les ports non nécessaires via pare-feu',
      commonMistake: 'Laisser les ports de test ouverts en production',
    ),
    prerequisites: const ['network-basics'],
  ),
  _course(
    id: 'linux-cyber',
    title: 'Linux pour débutants cyber',
    level: CourseLevel.intermediate,
    category: 'Systèmes',
    duration: 28,
    xp: 85,
    description: 'Commandes Linux utiles pour observation, audit et hygiène système.',
    objectives: const [
      'Naviguer dans le système de fichiers',
      'Lire droits et permissions',
      'Analyser des commandes d’administration sûres',
    ],
    lessons: _lessons('l’usage défensif de Linux'),
    quiz: _quiz(
      topic: 'l’administration Linux',
      secureAction: 'Appliquer des permissions minimales nécessaires',
      commonMistake: 'Utiliser des privilèges root en permanence',
    ),
    prerequisites: const ['ports-services'],
  ),
  _course(
    id: 'logs-monitoring',
    title: 'Logs et surveillance',
    level: CourseLevel.intermediate,
    category: 'Détection',
    duration: 30,
    xp: 90,
    description: 'Lire les journaux, corréler les événements et détecter les anomalies.',
    objectives: const [
      'Comprendre les sources de logs',
      'Construire une alerte utile',
      'Éviter le bruit de supervision',
    ],
    lessons: _lessons('la surveillance et l’observabilité sécurité'),
    quiz: _quiz(
      topic: 'les logs',
      secureAction: 'Centraliser les journaux critiques avec rétention',
      commonMistake: 'Ne conserver aucun historique',
    ),
    prerequisites: const ['linux-cyber'],
  ),
  _course(
    id: 'sqli-awareness',
    title: 'SQL Injection Awareness',
    level: CourseLevel.advanced,
    category: 'Sécurité applicative',
    duration: 32,
    xp: 100,
    description: 'Comprendre les risques SQLi et les mesures de prévention côté défense.',
    objectives: const [
      'Identifier des patterns de requêtes dangereuses',
      'Utiliser des requêtes paramétrées',
      'Valider et journaliser les entrées',
    ],
    lessons: _lessons('la prévention de l’injection SQL'),
    quiz: _quiz(
      topic: 'la sécurité SQL',
      secureAction: 'Utiliser des requêtes préparées et validation serveur',
      commonMistake: 'Concaténer directement les entrées utilisateur',
    ),
    prerequisites: const ['logs-monitoring'],
  ),
  _course(
    id: 'xss-web',
    title: 'XSS et sécurité web',
    level: CourseLevel.advanced,
    category: 'Sécurité web',
    duration: 33,
    xp: 105,
    description: 'Prévenir l’injection de scripts via encodage et politique de contenu.',
    objectives: const [
      'Différencier XSS réfléchi et stocké',
      'Appliquer encodage contextuel',
      'Renforcer avec CSP',
    ],
    lessons: _lessons('la prévention XSS'),
    quiz: _quiz(
      topic: 'les risques XSS',
      secureAction: 'Échapper la sortie selon le contexte HTML/JS',
      commonMistake: 'Afficher directement l’entrée utilisateur non filtrée',
    ),
    prerequisites: const ['sqli-awareness'],
  ),
  _course(
    id: 'bruteforce-defense',
    title: 'Brute force et défense',
    level: CourseLevel.advanced,
    category: 'Défense identité',
    duration: 29,
    xp: 110,
    description: 'Détecter les tentatives de brute force et limiter leur impact.',
    objectives: const [
      'Mettre en place rate limiting',
      'Détecter échecs d’authentification anormaux',
      'Concevoir une réponse graduée',
    ],
    lessons: _lessons('la défense contre la force brute'),
    quiz: _quiz(
      topic: 'les attaques par force brute',
      secureAction: 'Combiner MFA, verrouillage progressif et alertes',
      commonMistake: 'Autoriser tentatives illimitées',
    ),
    prerequisites: const ['xss-web'],
  ),
  _course(
    id: 'secure-app',
    title: 'Sécurisation d’application',
    level: CourseLevel.advanced,
    category: 'AppSec',
    duration: 35,
    xp: 120,
    description: 'Intégrer la sécurité dans le cycle de développement.',
    objectives: const [
      'Adopter Secure by Design',
      'Introduire revues de code orientées sécurité',
      'Préparer un plan de correction',
    ],
    lessons: _lessons('l’intégration de la sécurité applicative'),
    quiz: _quiz(
      topic: 'la sécurisation logicielle',
      secureAction: 'Automatiser des contrôles sécurité dans la CI',
      commonMistake: 'Traiter la sécurité uniquement en fin de projet',
    ),
    prerequisites: const ['bruteforce-defense'],
  ),
  _course(
    id: 'pentest-method',
    title: 'Méthodologie pentest',
    level: CourseLevel.expert,
    category: 'Gouvernance',
    duration: 38,
    xp: 130,
    description: 'Comprendre une méthodologie d’évaluation encadrée et éthique.',
    objectives: const [
      'Structurer une mission de test autorisé',
      'Définir périmètre et règles d’engagement',
      'Restituer de façon responsable',
    ],
    lessons: _lessons('la méthodologie de test de sécurité encadré'),
    quiz: _quiz(
      topic: 'la méthode pentest',
      secureAction: 'Obtenir autorisation explicite et périmètre défini',
      commonMistake: 'Lancer des tests sans cadre légal',
    ),
    prerequisites: const ['secure-app'],
  ),
  _course(
    id: 'incident-response',
    title: 'Incident response',
    level: CourseLevel.expert,
    category: 'Blue Team',
    duration: 40,
    xp: 140,
    description: 'Organiser détection, confinement, éradication et retour d’expérience.',
    objectives: const [
      'Conduire une réponse structurée',
      'Préserver les preuves',
      'Piloter la communication de crise',
    ],
    lessons: _lessons('la réponse à incident'),
    quiz: _quiz(
      topic: 'la gestion d’incident',
      secureAction: 'Isoler les systèmes touchés puis analyser méthodiquement',
      commonMistake: 'Supprimer les traces avant investigation',
    ),
    prerequisites: const ['pentest-method'],
  ),
  _course(
    id: 'threat-modeling',
    title: 'Threat modeling',
    level: CourseLevel.expert,
    category: 'Architecture',
    duration: 36,
    xp: 145,
    description: 'Anticiper les menaces dès la conception des systèmes.',
    objectives: const [
      'Identifier actifs, frontières et flux',
      'Lister scénarios de menace',
      'Prioriser les mitigations',
    ],
    lessons: _lessons('la modélisation des menaces'),
    quiz: _quiz(
      topic: 'le threat modeling',
      secureAction: 'Cartographier les flux et frontières de confiance',
      commonMistake: 'Ignorer les dépendances tierces',
    ),
    prerequisites: const ['incident-response'],
  ),
  _course(
    id: 'defense-depth',
    title: 'Défense en profondeur',
    level: CourseLevel.expert,
    category: 'Stratégie',
    duration: 42,
    xp: 160,
    description: 'Combiner les couches de sécurité pour limiter les impacts.',
    objectives: const [
      'Définir des contrôles complémentaires',
      'Éviter le point de défaillance unique',
      'Mesurer l’efficacité globale',
    ],
    lessons: _lessons('la stratégie de défense en profondeur'),
    quiz: _quiz(
      topic: 'la défense multi-couches',
      secureAction: 'Empiler prévention, détection et réponse',
      commonMistake: 'Compter sur un seul outil de sécurité',
    ),
    prerequisites: const ['threat-modeling'],
  ),
];
