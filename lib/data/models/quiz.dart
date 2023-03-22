// To parse this JSON data, do
//
//     final quiz = quizFromJson(jsonString);
import 'dart:convert';

class Quiz {
  Quiz({
    required this.userId,
    required this.title,
    required this.description,
    required this.popularity,
    required this.questions,
  });

  final String userId;
  final String title;
  final String description;
  final int popularity;
  final List<Question> questions;

  factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
        userId: json["userId"],
        title: json["title"],
        description: json["description"],
        popularity: json["popularity"],
        questions: List<Question>.from(
            json["questions"].map((x) => Question.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "title": title,
        "description": description,
        "popularity": popularity,
        "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
      };

  static Quiz quizFromJson(String str) => Quiz.fromJson(json.decode(str));

  static String quizToJson(Quiz data) => json.encode(data.toJson());
}

class Question {
  Question({
    required this.question,
    required this.options,
    required this.answer,
  });

  final String question;
  final List<String> options;
  final int answer;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        question: json["question"],
        options: List<String>.from(json["options"].map((x) => x)),
        answer: json["answer"],
      );

  Map<String, dynamic> toJson() => {
        "question": question,
        "options": List<dynamic>.from(options.map((x) => x)),
        "answer": answer,
      };

  static List<Question> questionsFromJson(String str) =>
      List<Question>.from(json.decode(str).map((x) => Question.fromJson(x)));

  static String questionsToJson(List<Question> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  static Question questionFromJson(String str) =>
      Question.fromJson(json.decode(str));

  static String questionToJson(Question data) => json.encode(data.toJson());
}
