import '../domain/daily_challenge_model.dart';

const List<DailyChallengeModel> dailyChallengeTemplates = [
  DailyChallengeModel(
    templateId: 'mail-01',
    title: 'Urgence Email',
    category: 'Phishing',
    prompt: 'Un email réclame un virement immédiat. Quelle première action défensive ?',
    options: [
      'Vérifier canal secondaire + identité du demandeur',
      'Exécuter rapidement pour éviter un retard',
      'Transférer le message sans vérification',
      'Désactiver les alertes anti-phishing',
    ],
    correctOptionIndex: 0,
    explanation:
        'La vérification hors bande réduit fortement le risque de fraude au président et d’usurpation.',
    xpReward: 25,
  ),
  DailyChallengeModel(
    templateId: 'auth-02',
    title: 'Accès Compromis',
    category: 'Identité',
    prompt: 'Des connexions inconnues apparaissent sur un compte admin. Que faire d’abord ?',
    options: [
      'Forcer reset mot de passe + révoquer sessions + MFA',
      'Attendre pour observer',
      'Partager le compte avec l’équipe SOC',
      'Supprimer les logs de connexion',
    ],
    correctOptionIndex: 0,
    explanation:
        'Le confinement identité est prioritaire: réinitialisation, invalidation des sessions et MFA.',
    xpReward: 30,
  ),
  DailyChallengeModel(
    templateId: 'net-03',
    title: 'Port Exposé',
    category: 'Réseaux',
    prompt: 'Un service base de données est exposé publiquement. Meilleure décision ?',
    options: [
      'Restreindre au réseau interne et pare-feu strict',
      'Ouvrir encore plus de ports pour homogénéité',
      'Couper toutes les sauvegardes',
      'Ignorer car le service répond vite',
    ],
    correctOptionIndex: 0,
    explanation:
        'Les services sensibles doivent être isolés et strictement filtrés.',
    xpReward: 35,
  ),
  DailyChallengeModel(
    templateId: 'web-04',
    title: 'Entrées Utilisateur',
    category: 'AppSec',
    prompt: 'Quelle pratique réduit le risque d’injection SQL ?',
    options: [
      'Requêtes paramétrées + validation côté serveur',
      'Concaténation directe des champs utilisateur',
      'Masquer uniquement les messages d’erreur',
      'Désactiver les tests unitaires',
    ],
    correctOptionIndex: 0,
    explanation:
        'La paramétrisation des requêtes est le contrôle principal contre SQLi.',
    xpReward: 35,
  ),
  DailyChallengeModel(
    templateId: 'xss-05',
    title: 'Sortie HTML',
    category: 'Sécurité Web',
    prompt: 'Quel mécanisme est essentiel contre le XSS stocké ?',
    options: [
      'Encodage contextuel de la sortie',
      'Désactiver CSP et logs',
      'Exécuter les scripts utilisateur directement',
      'Retirer la validation d’entrée',
    ],
    correctOptionIndex: 0,
    explanation:
        'L’encodage selon le contexte d’affichage bloque l’exécution de scripts injectés.',
    xpReward: 35,
  ),
  DailyChallengeModel(
    templateId: 'ir-06',
    title: 'Réponse Incident',
    category: 'Blue Team',
    prompt: 'Pendant un incident, quel ordre est le plus juste ?',
    options: [
      'Contenir, préserver preuves, analyser, remédier',
      'Redémarrer tout sans trace',
      'Supprimer journaux puis investiguer',
      'Reporter la réponse à plus tard',
    ],
    correctOptionIndex: 0,
    explanation:
        'La réponse efficace suit un processus structuré et traçable.',
    xpReward: 40,
  ),
  DailyChallengeModel(
    templateId: 'logs-07',
    title: 'Signal ou Bruit',
    category: 'Détection',
    prompt: 'Quel indicateur mérite une alerte immédiate ?',
    options: [
      'Pic d’échecs MFA sur comptes sensibles',
      'Changement de fond d’écran local',
      'Ouverture d’une application bureautique',
      'Diminution du volume audio système',
    ],
    correctOptionIndex: 0,
    explanation:
        'Les anomalies auth sur comptes critiques sont hautement prioritaires.',
    xpReward: 30,
  ),
];
