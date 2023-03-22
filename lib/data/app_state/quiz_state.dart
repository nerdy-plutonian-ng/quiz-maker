import 'package:flutter/foundation.dart';

import '../models/quiz.dart';

class QuizState with ChangeNotifier {
  ///title
  String? title;

  setTitle(String title) {
    this.title = title;
  }

  ///description
  String? description;

  setDescription(String description) {
    this.description = description;
  }

  ///questions

  List<Question>? questions;

  setQuestions(List<Question> questions) {
    this.questions = questions;
  }

  addQuestion(Question question) {
    if (questions == null) {
      questions = [question];
    } else {
      questions?.add(question);
    }
    notifyListeners();
  }

  removeQuestion(int index) {
    questions?.removeAt(index);
    notifyListeners();
  }

  updateQuestion(int index, Question question) {
    questions?[index] = question;
    notifyListeners();
  }

  ///reset
  reset() {
    title = null;
    description = null;
    questions = null;
  }
}
