enum CourseLevel { beginner, intermediate, advanced, expert }

extension CourseLevelLabel on CourseLevel {
  String get label {
    switch (this) {
      case CourseLevel.beginner:
        return 'Débutant';
      case CourseLevel.intermediate:
        return 'Intermédiaire';
      case CourseLevel.advanced:
        return 'Avancé';
      case CourseLevel.expert:
        return 'Expert';
    }
  }
}

class LessonSection {
  const LessonSection({required this.title, required this.content});

  final String title;
  final String content;
}

class CourseQuizQuestion {
  const CourseQuizQuestion({
    required this.prompt,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
  });

  final String prompt;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;
}

class CourseModel {
  const CourseModel({
    required this.id,
    required this.title,
    required this.level,
    required this.category,
    required this.durationMinutes,
    required this.xpReward,
    required this.description,
    required this.objectives,
    required this.lessons,
    required this.quiz,
    required this.prerequisites,
  });

  final String id;
  final String title;
  final CourseLevel level;
  final String category;
  final int durationMinutes;
  final int xpReward;
  final String description;
  final List<String> objectives;
  final List<LessonSection> lessons;
  final List<CourseQuizQuestion> quiz;
  final List<String> prerequisites;
}
