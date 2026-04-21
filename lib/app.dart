import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/providers/hacksim_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/campaigns/presentation/campaigns_screen.dart';
import 'features/courses/presentation/course_detail_screen.dart';
import 'features/courses/presentation/course_quiz_screen.dart';
import 'features/challenges/presentation/daily_challenge_screen.dart';
import 'features/courses/presentation/courses_screen.dart';
import 'features/help/presentation/user_guide_screen.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/home/presentation/main_shell.dart';
import 'features/missions/presentation/mission_detail_screen.dart';
import 'features/missions/presentation/missions_screen.dart';
import 'features/onboarding/presentation/onboarding_screen.dart';
import 'features/profile/presentation/profile_screen.dart';
import 'features/progression/presentation/progression_screen.dart';
import 'features/settings/presentation/settings_screen.dart';

class HackSimApp extends ConsumerWidget {
  const HackSimApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(hackSimControllerProvider);
    return MaterialApp(
      title: 'HackSim',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: controller.onboardingSeen
          ? const MainShell()
          : const OnboardingScreen(),
      routes: {
        CampaignsScreen.routeName: (_) => const CampaignsScreen(),
        DailyChallengeScreen.routeName: (_) => const DailyChallengeScreen(),
        UserGuideScreen.routeName: (_) => const UserGuideScreen(),
        SettingsScreen.routeName: (_) => const SettingsScreen(),
        CoursesScreen.routeName: (_) => const CoursesScreen(),
        MissionsScreen.routeName: (_) => const MissionsScreen(),
        ProgressionScreen.routeName: (_) => const ProgressionScreen(),
        ProfileScreen.routeName: (_) => const ProfileScreen(),
        '/legacy-home': (_) => const HomeScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == CourseDetailScreen.routeName) {
          return MaterialPageRoute<void>(
            builder: (_) => CourseDetailScreen(courseId: settings.arguments! as String),
          );
        }
        if (settings.name == CourseQuizScreen.routeName) {
          return MaterialPageRoute<void>(
            builder: (_) => CourseQuizScreen(courseId: settings.arguments! as String),
          );
        }
        if (settings.name == MissionDetailScreen.routeName) {
          return MaterialPageRoute<void>(
            builder: (_) => MissionDetailScreen(missionId: settings.arguments! as String),
          );
        }
        return null;
      },
    );
  }
}
