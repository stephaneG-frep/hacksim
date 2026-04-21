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

  factory LessonSection.fromJson(Map<String, dynamic> json) {
    return LessonSection(
      title: json['title'] as String,
      content: json['content'] as String,
    );
  }
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

  factory CourseQuizQuestion.fromJson(Map<String, dynamic> json) {
    return CourseQuizQuestion(
      prompt: json['prompt'] as String,
      options: List<String>.from(json['options'] as List),
      correctOptionIndex: json['correctOptionIndex'] as int,
      explanation: json['explanation'] as String,
    );
  }
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

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    final levelStr = json['level'] as String;
    final level = CourseLevel.values.firstWhere(
      (l) => l.name == levelStr,
      orElse: () => CourseLevel.beginner,
    );
    return CourseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      level: level,
      category: json['category'] as String,
      durationMinutes: json['durationMinutes'] as int,
      xpReward: json['xpReward'] as int,
      description: json['description'] as String,
      objectives: List<String>.from(json['objectives'] as List),
      lessons: (json['lessons'] as List).map((l) => LessonSection.fromJson(l as Map<String, dynamic>)).toList(),
      quiz: (json['quiz'] as List).map((q) => CourseQuizQuestion.fromJson(q as Map<String, dynamic>)).toList(),
      prerequisites: List<String>.from((json['prerequisites'] as List?) ?? []),
    );
  }
}
