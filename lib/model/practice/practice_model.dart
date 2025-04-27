class Question {
  final String question;
  final List<String> options;
  final String answer;

  Question({
    required this.question,
    required this.options,
    required this.answer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List),
      answer: json['answer'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options,
      'answer': answer,
    };
  }
}

// models/level_questions.dart
class LevelQuestions {
  final List<Question> a1;
  final List<Question> a2;
  final List<Question> b1;
  final List<Question> b2;
  final List<Question> c1;
  final List<Question> c2;

  LevelQuestions({
    required this.a1,
    required this.a2,
    required this.b1,
    required this.b2,
    required this.c1,
    required this.c2,
  });

  factory LevelQuestions.fromJson(Map<String, dynamic> json) {
    return LevelQuestions(
      a1: (json['A1'] as List).map((q) => Question.fromJson(q)).toList(),
      a2: (json['A2'] as List).map((q) => Question.fromJson(q)).toList(),
      b1: (json['B1'] as List).map((q) => Question.fromJson(q)).toList(),
      b2: (json['B2'] as List).map((q) => Question.fromJson(q)).toList(),
      c1: (json['C1'] as List).map((q) => Question.fromJson(q)).toList(),
      c2: (json['C2'] as List).map((q) => Question.fromJson(q)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'A1': a1.map((q) => q.toJson()).toList(),
      'A2': a2.map((q) => q.toJson()).toList(),
      'B1': b1.map((q) => q.toJson()).toList(),
      'B2': b2.map((q) => q.toJson()).toList(),
      'C1': c1.map((q) => q.toJson()).toList(),
      'C2': c2.map((q) => q.toJson()).toList(),
    };
  }
}