import 'package:flutter/foundation.dart';

class CreateQuizState with ChangeNotifier {
  List<Map<String, dynamic>> questions = [];
  int? index;

  selectIndex(int? index) {
    this.index = index;
  }

  setQuestions(List<Map<String, dynamic>> questions) {
    this.questions = questions;
  }

  addQuestion(Map<String, dynamic> question) {
    questions.add(question);
    notifyListeners();
  }

  removeQuestion(int index) {
    questions.removeAt(index);
    notifyListeners();
  }

  updateQuestion(int index, Map<String, dynamic> question) {
    questions[index] = question;
    notifyListeners();
  }

  reset() {
    questions.clear();
    index = null;
  }

  resetIndex() {
    index = null;
  }
}
