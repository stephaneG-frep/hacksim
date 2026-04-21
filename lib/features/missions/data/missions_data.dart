import '../domain/mission_model.dart';

const List<MissionModel> missionsData = [
  MissionModel(
    id: 'password-breach',
    title: 'Password Breach',
    difficulty: 'Facile',
    category: 'Authentification',
    xpReward: 80,
    scenario:
        'Une équipe remarque des connexions suspectes sur des comptes partagés. Ta mission est de contenir le risque et renforcer l’authentification.',
    requiredXp: 0,
    prerequisiteCourses: ['password-auth'],
    steps: [
      MissionStep(
        title: 'Étape 1 - Signal faible',
        prompt: 'Quel indicateur est le plus prioritaire ?',
        options: [
          'Pics d’échecs de connexion sur plusieurs comptes',
          'Changement de fond d’écran utilisateur',
          'Suppression d’un vieux fichier local',
        ],
        correctOptionIndex: 0,
        explanation:
            'Un volume anormal d’échecs d’authentification est un indicateur classique de tentative d’accès illégitime.',
      ),
      MissionStep(
        title: 'Étape 2 - Action immédiate',
        prompt: 'Quelle mesure défensive appliquer en premier ?',
        options: [
          'Forcer la rotation des mots de passe + activer MFA',
          'Désactiver tous les logs',
          'Partager un mot de passe temporaire commun',
        ],
        correctOptionIndex: 0,
        explanation:
            'La réduction du risque passe par la rotation des secrets et l’ajout d’un second facteur.',
      ),
      MissionStep(
        title: 'Étape 3 - Prévention durable',
        prompt: 'Quelle politique limite les incidents futurs ?',
        options: [
          'Gestionnaire de mots de passe + longueur minimale + MFA',
          'Un mot de passe unique pour toute l’équipe',
          'Suppression des alertes de sécurité',
        ],
        correctOptionIndex: 0,
        explanation:
            'Une politique d’identité forte combine bonnes pratiques utilisateurs et contrôles techniques.',
      ),
    ],
  ),
  MissionModel(
    id: 'phishing-alert',
    title: 'Phishing Alert',
    difficulty: 'Facile',
    category: 'Ingénierie sociale',
    xpReward: 90,
    scenario:
        'Des emails “urgence paiement” circulent. Tu dois aider l’équipe à trier le vrai du faux sans cliquer sur des liens risqués.',
    requiredXp: 0,
    prerequisiteCourses: ['phishing'],
    steps: [
      MissionStep(
        title: 'Étape 1 - Inspection',
        prompt: 'Quel élément vérifies-tu en priorité ?',
        options: [
          'Domaine exact de l’expéditeur',
          'Couleur du logo dans l’email',
          'Position du message dans la boîte',
        ],
        correctOptionIndex: 0,
        explanation:
            'Le domaine réel de l’expéditeur et des liens est un signal décisif pour détecter l’usurpation.',
      ),
      MissionStep(
        title: 'Étape 2 - Lien suspect',
        prompt: 'Un lien affiche “intranet-entreprise.com” mais pointe ailleurs. Que faire ?',
        options: [
          'Ne pas cliquer, signaler immédiatement',
          'Cliquer depuis un mobile personnel',
          'Transférer le lien à tous pour avis',
        ],
        correctOptionIndex: 0,
        explanation:
            'Le texte visible peut masquer une URL malveillante. La bonne pratique est de ne pas exécuter et de signaler.',
      ),
      MissionStep(
        title: 'Étape 3 - Sensibilisation',
        prompt: 'Quel message diffuser à l’équipe ?',
        options: [
          'Toujours vérifier expéditeur, URL, urgence artificielle et demandes sensibles',
          'Répondre à tous les emails suspects',
          'Ignorer les emails de sécurité',
        ],
        correctOptionIndex: 0,
        explanation:
            'La pédagogie collective réduit fortement le risque d’ingénierie sociale.',
      ),
    ],
  ),
  MissionModel(
    id: 'port-scan-basics',
    title: 'Port Scan Basics',
    difficulty: 'Moyen',
    category: 'Réseaux',
    xpReward: 120,
    scenario:
        'Tu analyses un serveur simulé qui expose plusieurs services. Objectif: réduire la surface d’exposition.',
    requiredXp: 0,
    prerequisiteCourses: ['ports-services'],
    steps: [
      MissionStep(
        title: 'Étape 1 - Lecture terminal simulée',
        prompt: 'Le scan simulé indique ports 22, 80, 3306 ouverts. Quelle décision est la plus sûre ?',
        options: [
          'Fermer 3306 en accès public et restreindre au réseau interne',
          'Ouvrir tous les ports 1-65535 pour simplifier',
          'Désactiver totalement le pare-feu',
        ],
        correctOptionIndex: 0,
        explanation:
            'Les bases de données ne doivent pas être exposées publiquement sans nécessité et contrôle strict.',
        commandChallenge: "net-sim scan target-01",
        commandHint: "net-sim scan <cible>",
        commandOutput: "[SIM] open: 22/tcp ssh\n[SIM] open: 80/tcp http\n[SIM] open: 3306/tcp mysql\n[SIM] Scan complet.",
      ),
      MissionStep(
        title: 'Étape 2 - Contrôle d’accès',
        prompt: 'Quelle stratégie appliquer au service SSH ?',
        options: [
          'Limiter par IP autorisées et clés fortes',
          'Autoriser mot de passe faible pour tous',
          'Désactiver toute journalisation',
        ],
        correctOptionIndex: 0,
        explanation:
            'Le contrôle d’accès fort sur SSH limite les tentatives automatiques et améliore la traçabilité.',
      ),
      MissionStep(
        title: 'Étape 3 - Monitoring',
        prompt: 'Quel indicateur suivre après durcissement ?',
        options: [
          'Tentatives de connexion refusées et alertes pare-feu',
          'Nombre de fonds d’écran changés',
          'Nombre de redémarrages manuels',
        ],
        correctOptionIndex: 0,
        explanation:
            'Les événements réseau et auth permettent de vérifier l’efficacité des mesures.',
      ),
    ],
  ),
  MissionModel(
    id: 'sql-awareness-mission',
    title: 'SQL Injection Awareness',
    difficulty: 'Difficile',
    category: 'Sécurité web',
    xpReward: 140,
    scenario:
        'Une application simulée retourne des erreurs SQL après saisie utilisateur. Tu dois proposer des corrections défensives.',
    requiredXp: 0,
    prerequisiteCourses: ['sqli-awareness'],
    steps: [
      MissionStep(
        title: 'Étape 1 - Cause probable',
        prompt: 'Quelle cause explique le risque SQLi ?',
        options: [
          'Concaténation directe des entrées dans la requête',
          'Utilisation de requêtes préparées',
          'Validation stricte côté serveur',
        ],
        correctOptionIndex: 0,
        explanation:
            'La concaténation brute d’entrées utilisateur est la cause classique des injections SQL.',
        commandChallenge: "db-sim inspect-log",
        commandHint: "db-sim inspect-log",
        commandOutput: "[SIM] query: SELECT * FROM users WHERE email='input' AND pass='input'\n[SIM] WARNING: SQLi risk HIGH",
      ),
      MissionStep(
        title: 'Étape 2 - Remédiation',
        prompt: 'Quelle correction doit être priorisée ?',
        options: [
          'Paramétrer les requêtes et valider les entrées',
          'Masquer les erreurs sans corriger le code',
          'Supprimer toute authentification',
        ],
        correctOptionIndex: 0,
        explanation:
            'Le correctif structurel est la paramétrisation + validation, pas le masquage.',
      ),
      MissionStep(
        title: 'Étape 3 - Contrôle continu',
        prompt: 'Quel garde-fou long terme ?',
        options: [
          'Revues de code sécurité + tests automatisés d’entrées',
          'Ne plus modifier le code applicatif',
          'Désactiver les logs applicatifs',
        ],
        correctOptionIndex: 0,
        explanation:
            'La prévention durable repose sur le cycle de développement sécurisé.',
      ),
    ],
  ),
  MissionModel(
    id: 'server-defense',
    title: 'Server Defense',
    difficulty: 'Expert',
    category: 'Blue Team',
    xpReward: 180,
    scenario:
        'Un serveur critique présente des anomalies de trafic et de comptes. Tu dois coordonner une réponse défensive complète.',
    requiredXp: 0,
    prerequisiteCourses: ['incident-response', 'defense-depth'],
    steps: [
      MissionStep(
        title: 'Étape 1 - Confinement',
        prompt: 'Quelle action initiale est la plus adaptée ?',
        options: [
          'Isoler le serveur du segment non critique tout en conservant les preuves',
          'Redémarrer immédiatement sans collecte',
          'Supprimer les logs pour gagner de la place',
        ],
        correctOptionIndex: 0,
        explanation:
            'La réponse à incident commence par le confinement et la préservation de preuves.',
      ),
      MissionStep(
        title: 'Étape 2 - Analyse guidée',
        prompt: 'Quel artefact est prioritaire pour comprendre l’incident ?',
        options: [
          'Timeline corrélée logs système + auth + réseau',
          'Historique des thèmes visuels du serveur',
          'Liste des fichiers temporaires non système seulement',
        ],
        correctOptionIndex: 0,
        explanation:
            'La corrélation multi-source est indispensable pour établir la chronologie fiable.',
        commandChallenge: "ir-sim timeline --sources auth,syslog,netflow",
        commandHint: "ir-sim timeline --sources auth,syslog,netflow",
        commandOutput: "[SIM] 03:12 suspicious login burst — 48 attempts\n[SIM] 03:14 lateral movement attempt BLOCKED\n[SIM] Timeline exportée.",
      ),
      MissionStep(
        title: 'Étape 3 - Durcissement final',
        prompt: 'Quel plan est le plus robuste ?',
        options: [
          'Patch, segmentation, MFA admin, alertes SIEM, revue post-incident',
          'Revenir à la configuration précédente sans analyse',
          'Désactiver les alertes pour réduire le bruit',
        ],
        correctOptionIndex: 0,
        explanation:
            'Une défense en profondeur combine correctifs, identité forte, surveillance et amélioration continue.',
      ),
    ],
  ),
  MissionModel(
    id: 'log-hunter',
    title: 'Log Hunter',
    difficulty: 'Difficile',
    category: 'Détection',
    xpReward: 155,
    scenario:
        'Une alerte de connexion anormale est remontée. Tu dois trier signal et bruit dans les logs simulés.',
    requiredXp: 0,
    prerequisiteCourses: ['logs-monitoring'],
    steps: [
      MissionStep(
        title: 'Étape 1 - Priorisation',
        prompt: 'Quel événement est le plus suspect ?',
        options: [
          'Plusieurs échecs MFA suivis d’une réussite depuis une IP inconnue',
          'Un redémarrage planifié validé en maintenance',
          'Un accès à la documentation interne',
        ],
        correctOptionIndex: 0,
        explanation:
            'La séquence échecs successifs puis réussite inattendue est typique d’un comportement à investiguer.',
      ),
      MissionStep(
        title: 'Étape 2 - Corrélation',
        prompt: 'Quelle source croiser ensuite ?',
        options: [
          'Netflow et logs endpoint de la même fenêtre temporelle',
          'Historique des fonds d’écran',
          'Statistiques de batterie des laptops',
        ],
        correctOptionIndex: 0,
        explanation:
            'La corrélation réseau + poste de travail améliore la fiabilité de l’analyse.',
      ),
      MissionStep(
        title: 'Étape 3 - Mesure défensive',
        prompt: 'Quelle action est la plus adaptée ?',
        options: [
          'Bloquer l’IP, réinitialiser le compte, ouvrir un ticket d’incident',
          'Supprimer tous les logs pour alléger le SIEM',
          'Attendre plusieurs jours sans action',
        ],
        correctOptionIndex: 0,
        explanation:
            'La réponse doit être traçable, rapide et coordonnée pour limiter la fenêtre d’attaque.',
      ),
    ],
  ),
  MissionModel(
    id: 'secure-release',
    title: 'Secure Release Gate',
    difficulty: 'Expert',
    category: 'DevSecOps',
    xpReward: 190,
    scenario:
        'Ton équipe prépare une release. Tu dois valider une checklist sécurité avant déploiement en production simulée.',
    requiredXp: 0,
    prerequisiteCourses: ['secure-app', 'defense-depth'],
    steps: [
      MissionStep(
        title: 'Étape 1 - Pré-check',
        prompt: 'Quelle vérification doit bloquer une release ?',
        options: [
          'Vulnérabilité critique non corrigée dans une dépendance exposée',
          'Nom de branche non conventionnel',
          'Couleur du thème non finalisée',
        ],
        correctOptionIndex: 0,
        explanation:
            'Une dépendance vulnérable critique est un risque immédiat à traiter avant mise en production.',
      ),
      MissionStep(
        title: 'Étape 2 - Secret management',
        prompt: 'Quel choix est correct pour les secrets ?', 
        options: [
          'Stockage dans un coffre dédié et rotation planifiée',
          'Secrets en clair dans le dépôt',
          'Partage du token admin dans le chat équipe',
        ],
        correctOptionIndex: 0,
        explanation:
            'Les secrets doivent être externalisés et rotés pour réduire exposition et impact.', 
      ),
      MissionStep(
        title: 'Étape 3 - Go/No-Go',
        prompt: 'Quand autoriser le déploiement ?', 
        options: [
          'Après correction critique + tests sécurité passants + plan rollback',
          'Dès que les tests visuels sont valides',
          'Sans journalisation pour maximiser performances',
        ],
        correctOptionIndex: 0,
        explanation:
            'Le go-live sécurisé combine remédiation, validation et capacité de retour arrière.',
      ),
    ],
  ),
  MissionModel(
    id: 'mobile-lockdown',
    title: 'Mobile Lockdown',
    difficulty: 'Moyen',
    category: 'Poste utilisateur',
    xpReward: 115,
    scenario:
        'Un smartphone professionnel est perdu. Tu dois sécuriser l’accès aux données et limiter l’exposition.',
    requiredXp: 0,
    prerequisiteCourses: ['mobile-security-basics'],
    steps: [
      MissionStep(
        title: 'Étape 1 - Première réponse',
        prompt: 'Quelle action est prioritaire ?',
        options: [
          'Déclencher verrouillage/effacement à distance via MDM',
          'Attendre un retour utilisateur',
          'Désactiver tous les comptes de toute l’entreprise',
        ],
        correctOptionIndex: 0,
        explanation:
            'Le contrôle à distance est la meilleure réponse immédiate pour protéger les données mobiles.',
      ),
      MissionStep(
        title: 'Étape 2 - Compte associé',
        prompt: 'Que faire sur le compte de l’utilisateur ?',
        options: [
          'Révoquer sessions actives et forcer MFA/rotation',
          'Laisser les sessions ouvertes pour surveillance',
          'Partager un mot de passe temporaire générique',
        ],
        correctOptionIndex: 0,
        explanation:
            'La révocation de session réduit rapidement le risque d’accès frauduleux.',
      ),
      MissionStep(
        title: 'Étape 3 - Prévention',
        prompt: 'Quel contrôle évite ce type d’incident à l’avenir ?',
        options: [
          'Politique MDM + chiffrement + conformité appareils',
          'Interdire les mises à jour système',
          'Supprimer le verrouillage biométrique',
        ],
        correctOptionIndex: 0,
        explanation:
            'Une politique mobile complète combine chiffrement, conformité et contrôle centralisé.',
      ),
    ],
  ),
  MissionModel(
    id: 'backup-recovery-drill',
    title: 'Backup Recovery Drill',
    difficulty: 'Moyen',
    category: 'Résilience',
    xpReward: 125,
    scenario:
        'Après un incident simulé, plusieurs fichiers critiques sont indisponibles. Ta mission: restaurer de façon fiable.',
    requiredXp: 0,
    prerequisiteCourses: ['backup-recovery'],
    steps: [
      MissionStep(
        title: 'Étape 1 - Source de restauration',
        prompt: 'Quelle sauvegarde choisir en premier ?',
        options: [
          'Sauvegarde validée la plus récente avec test d’intégrité',
          'Copie locale non vérifiée',
          'Archive ancienne sans métadonnées',
        ],
        correctOptionIndex: 0,
        explanation:
            'La restauration doit s’appuyer sur une source vérifiée pour éviter corruption ou perte.',
      ),
      MissionStep(
        title: 'Étape 2 - Ordre de reprise',
        prompt: 'Quel ordre est recommandé ?',
        options: [
          'Restaurer services critiques puis données secondaires',
          'Restaurer au hasard pour aller vite',
          'Recréer les données manuellement sans sauvegarde',
        ],
        correctOptionIndex: 0,
        explanation:
            'La priorisation par criticité réduit l’impact métier.',
      ),
      MissionStep(
        title: 'Étape 3 - Amélioration continue',
        prompt: 'Quelle action clôture correctement l’exercice ?',
        options: [
          'Rédiger un retour d’expérience et ajuster RTO/RPO',
          'Supprimer les logs d’exercice',
          'Ne rien documenter car c’est un test',
        ],
        correctOptionIndex: 0,
        explanation:
            'La documentation post-exercice est indispensable pour améliorer la résilience.',
      ),
    ],
  ),
  MissionModel(
    id: 'iam-audit-rush',
    title: 'IAM Audit Rush',
    difficulty: 'Difficile',
    category: 'Identité',
    xpReward: 145,
    scenario:
        'Un audit révèle des privilèges excessifs. Tu dois corriger les accès sans casser la production simulée.',
    requiredXp: 0,
    prerequisiteCourses: ['iam-basics'],
    steps: [
      MissionStep(
        title: 'Étape 1 - Priorité',
        prompt: 'Quelle catégorie d’accès traiter d’abord ?',
        options: [
          'Comptes admin permanents non justifiés',
          'Comptes invités expirés déjà inactifs',
          'Comptes de test supprimés',
        ],
        correctOptionIndex: 0,
        explanation:
            'Les privilèges élevés non contrôlés représentent le risque le plus immédiat.',
      ),
      MissionStep(
        title: 'Étape 2 - Mesure',
        prompt: 'Quel mécanisme réduit le risque tout en gardant l’opérationnel ?',
        options: [
          'Accès just-in-time avec validation et expiration',
          'Rendre tout le monde admin temporairement',
          'Désactiver les journaux IAM',
        ],
        correctOptionIndex: 0,
        explanation:
            'Le modèle JIT réduit la durée d’exposition des privilèges sensibles.',
      ),
      MissionStep(
        title: 'Étape 3 - Contrôle durable',
        prompt: 'Que mettre en place ensuite ?',
        options: [
          'Revue périodique des droits et alertes sur élévation',
          'Aucune revue car le nettoyage est fait',
          'Partage de comptes pour simplifier',
        ],
        correctOptionIndex: 0,
        explanation:
            'La gouvernance IAM doit être continue, pas ponctuelle.',
      ),
    ],
  ),
  MissionModel(
    id: 'cloud-guardrails',
    title: 'Cloud Guardrails',
    difficulty: 'Difficile',
    category: 'Cloud',
    xpReward: 160,
    scenario:
        'Une configuration cloud simulée expose des ressources critiques. Tu dois appliquer des garde-fous.',
    requiredXp: 0,
    prerequisiteCourses: ['cloud-security-fundamentals'],
    steps: [
      MissionStep(
        title: 'Étape 1 - Diagnostic',
        prompt: 'Quel risque corriger en priorité ?',
        options: [
          'Stockage sensible accessible publiquement',
          'Tag de ressource manquant',
          'Nommage non homogène',
        ],
        correctOptionIndex: 0,
        explanation:
            'L’exposition publique de données sensibles doit être traitée immédiatement.',
      ),
      MissionStep(
        title: 'Étape 2 - Garde-fou technique',
        prompt: 'Quel contrôle automatique mettre en place ?',
        options: [
          'Policy bloquant toute ressource publique non approuvée',
          'Script manuel exécuté une fois par an',
          'Suppression de la journalisation cloud',
        ],
        correctOptionIndex: 0,
        explanation:
            'Les policy-as-code empêchent les dérives de configuration avant mise en prod.',
      ),
      MissionStep(
        title: 'Étape 3 - Vérification',
        prompt: 'Comment valider durablement la conformité ?',
        options: [
          'Scanner en continu et alerter sur dérive',
          'Contrôler uniquement après incident',
          'Désactiver les alertes pour réduire le bruit',
        ],
        correctOptionIndex: 0,
        explanation:
            'La conformité cloud nécessite un contrôle continu et une boucle d’alerte.',
      ),
    ],
  ),
  MissionModel(
    id: 'api-shield',
    title: 'API Shield',
    difficulty: 'Expert',
    category: 'Sécurité applicative',
    xpReward: 175,
    scenario:
        'Une API métier reçoit un trafic anormal. Tu dois renforcer l’authentification et limiter les abus.',
    requiredXp: 0,
    prerequisiteCourses: ['api-security-essentials'],
    steps: [
      MissionStep(
        title: 'Étape 1 - Authentification',
        prompt: 'Quel contrôle est prioritaire ?',
        options: [
          'Vérification stricte des tokens + scopes minimaux',
          'Autoriser tokens expirés en fallback',
          'Désactiver toute auth pour debug',
        ],
        correctOptionIndex: 0,
        explanation:
            'Le contrôle de validité et de périmètre des tokens protège les endpoints sensibles.',
      ),
      MissionStep(
        title: 'Étape 2 - Limitation d’abus',
        prompt: 'Quelle mesure limite efficacement les tentatives automatiques ?',
        options: [
          'Rate limiting + quotas par client',
          'Retirer les logs d’accès',
          'Augmenter timeout sans filtrage',
        ],
        correctOptionIndex: 0,
        explanation:
            'Le rate limiting réduit les attaques par volume et protège la disponibilité.',
      ),
      MissionStep(
        title: 'Étape 3 - Détection',
        prompt: 'Quel signal suivre en priorité ?',
        options: [
          'Hausse d’erreurs auth et pics sur endpoints sensibles',
          'Nombre de couleurs CSS chargées',
          'Temps de compilation local développeur',
        ],
        correctOptionIndex: 0,
        explanation:
            'Les anomalies auth/usage endpoint sont des indicateurs utiles d’abus API.',
      ),
    ],
  ),
  MissionModel(
    id: 'forensics-war-room',
    title: 'Forensics War Room',
    difficulty: 'Expert',
    category: 'Investigation',
    xpReward: 210,
    scenario:
        'Une intrusion simulée est suspectée. Tu dois piloter la collecte et l’analyse forensique sans altérer les preuves.',
    requiredXp: 0,
    prerequisiteCourses: ['digital-forensics', 'soc-playbooks'],
    steps: [
      MissionStep(
        title: 'Étape 1 - Préservation',
        prompt: 'Quelle action respecte la chaîne de conservation ?',
        options: [
          'Acquisition image disque/mémoire avant remédiation intrusive',
          'Suppression immédiate des fichiers suspects',
          'Redémarrage complet de tous les serveurs',
        ],
        correctOptionIndex: 0,
        explanation:
            'La préservation correcte des preuves est indispensable pour une analyse fiable.',
      ),
      MissionStep(
        title: 'Étape 2 - Corrélation',
        prompt: 'Quel jeu de données corréler ?',
        options: [
          'Logs auth, netflow et événements endpoint horodatés',
          'Documents marketing et assets graphiques',
          'Historique des thèmes IDE',
        ],
        correctOptionIndex: 0,
        explanation:
            'La corrélation multi-source permet de reconstruire la chronologie d’attaque.',
      ),
      MissionStep(
        title: 'Étape 3 - Restitution',
        prompt: 'Quel livrable final est le plus utile ?',
        options: [
          'Rapport chronologique avec impacts, preuves et recommandations',
          'Résumé sans preuves pour aller vite',
          'Aucune restitution écrite',
        ],
        correctOptionIndex: 0,
        explanation:
            'Un rapport structuré facilite la décision et la prévention future.',
      ),
    ],
  ),
];
