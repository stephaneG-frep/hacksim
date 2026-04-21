import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/hacksim_provider.dart';
import '../../../core/widgets/cyber_screen.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _index = 0;

  static const _pages = [
    (
      'Bienvenue dans HackSim',
      'Une application 100% pédagogique en cybersécurité défensive, du niveau débutant à expert.',
      Icons.security_rounded,
    ),
    (
      'Progresse étape par étape',
      'Valide les cours et quiz, débloque les missions simulées, cumule XP, badges et streak quotidien.',
      Icons.trending_up_rounded,
    ),
    (
      'Apprends en sécurité',
      'Aucune fonctionnalité offensive réelle: uniquement des scénarios encadrés et des bonnes pratiques.',
      Icons.verified_user_rounded,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CyberScreen(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (value) => setState(() => _index = value),
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return AnimatedCyberCard(
                    order: index,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(page.$3, size: 84, color: const Color(0xFF65FFBF)),
                        const SizedBox(height: 20),
                        Text(
                          page.$1,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 12),
                        Text(page.$2, textAlign: TextAlign.center),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (i) => Container(
                  width: i == _index ? 24 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: i == _index ? const Color(0xFF00E5A8) : Colors.white30,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                if (_index > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _pageController.previousPage(
                        duration: const Duration(milliseconds: 260),
                        curve: Curves.easeOut,
                      ),
                      child: const Text('Retour'),
                    ),
                  )
                else
                  const Spacer(),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_index < _pages.length - 1) {
                        await _pageController.nextPage(
                          duration: const Duration(milliseconds: 260),
                          curve: Curves.easeOut,
                        );
                        return;
                      }
                      await ref.read(hackSimControllerProvider).markOnboardingSeen();
                    },
                    child: Text(_index == _pages.length - 1 ? 'Commencer' : 'Suivant'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
