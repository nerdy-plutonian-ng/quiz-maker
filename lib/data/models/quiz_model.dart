// To parse this JSON data, do
//
//     final quizModel = quizModelFromJson(jsonString);

import 'dart:convert';

class QuizModel {
  QuizModel({
    required this.title,
    required this.questions,
  });

  final String title;
  final List<Question> questions;

  factory QuizModel.fromJson(Map<String, dynamic> json) => QuizModel(
        title: json["title"],
        questions: List<Question>.from(
            json["questions"].map((x) => Question.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
      };

  static QuizModel quizModelFromJson(String str) =>
      QuizModel.fromJson(json.decode(str));

  static String quizModelToJson(QuizModel data) => json.encode(data.toJson());
}

class Question {
  Question({
    required this.title,
    required this.choices,
    required this.answer,
  });

  final String title;
  final List<String> choices;
  final int answer;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        title: json["title"],
        choices: List<String>.from(json["choices"].map((x) => x)),
        answer: json["answer"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "choices": List<dynamic>.from(choices.map((x) => x)),
        "answer": answer,
      };
}
