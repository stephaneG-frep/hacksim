import 'package:flutter/material.dart';

import 'core/state/hacksim_controller.dart';
import 'core/theme/app_theme.dart';
import 'features/courses/presentation/course_detail_screen.dart';
import 'features/courses/presentation/course_quiz_screen.dart';
import 'features/courses/presentation/courses_screen.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/missions/presentation/mission_detail_screen.dart';
import 'features/missions/presentation/missions_screen.dart';
import 'features/profile/presentation/profile_screen.dart';
import 'features/progression/presentation/progression_screen.dart';

class HackSimApp extends StatelessWidget {
  const HackSimApp({super.key, required this.controller});

  final HackSimController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return MaterialApp(
          title: 'HackSim',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark,
          home: HomeScreen(controller: controller),
          routes: {
            CoursesScreen.routeName: (_) => CoursesScreen(controller: controller),
            MissionsScreen.routeName: (_) => MissionsScreen(controller: controller),
            ProgressionScreen.routeName: (_) => ProgressionScreen(controller: controller),
            ProfileScreen.routeName: (_) => ProfileScreen(controller: controller),
          },
          onGenerateRoute: (settings) {
            if (settings.name == CourseDetailScreen.routeName) {
              return MaterialPageRoute<void>(
                builder: (_) => CourseDetailScreen(
                  controller: controller,
                  courseId: settings.arguments! as String,
                ),
              );
            }
            if (settings.name == CourseQuizScreen.routeName) {
              return MaterialPageRoute<void>(
                builder: (_) => CourseQuizScreen(
                  controller: controller,
                  courseId: settings.arguments! as String,
                ),
              );
            }
            if (settings.name == MissionDetailScreen.routeName) {
              return MaterialPageRoute<void>(
                builder: (_) => MissionDetailScreen(
                  controller: controller,
                  missionId: settings.arguments! as String,
                ),
              );
            }
            return null;
          },
        );
      },
    );
  }
}
