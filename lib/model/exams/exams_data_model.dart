class Question {
  final String question;
  final List<String> options;
  final String answer;
  final String difficulty;
  final String createdAt;

  Question({
    required this.question,
    required this.options,
    required this.answer,
    required this.difficulty,
    required this.createdAt,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'] as String,
      options: (json['options'] as List).cast<String>(),
      answer: json['answer'] as String,
      difficulty: json['difficulty'] as String,
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'question': question,
    'options': options,
    'answer': answer,
    'difficulty': difficulty,
    'createdAt': createdAt,
  };
}

class ExamLevel {
  final Map<String, Question> questions;

  ExamLevel({required this.questions});

  factory ExamLevel.fromJson(Map<String, dynamic> json) {
    return ExamLevel(
      questions: (json['questions'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(
          key,
          Question.fromJson(value as Map<String, dynamic>),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questions': questions.map((key, q) => MapEntry(key, q.toJson())),
    };
  }
}

class ExamData {
  final Map<String, ExamLevel> exams;

  ExamData({required this.exams});

  factory ExamData.fromJson(Map<String, dynamic> json) {
    return ExamData(
      exams: (json['exams'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(
          key,
          ExamLevel.fromJson(value as Map<String, dynamic>),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exams': exams.map((key, level) => MapEntry(key, level.toJson())),
    };
  }
}