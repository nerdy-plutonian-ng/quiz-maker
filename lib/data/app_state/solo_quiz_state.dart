import 'package:flutter/foundation.dart';

class SoloQuizState with ChangeNotifier {
  ///question
  var currentQuestion = 0;

  nextQuestion() {
    currentQuestion++;
    notifyListeners();
  }

  ///score
  var score = 0;

  incrementScore() {
    score += 3;
    notifyListeners();
  }

  ///game over
  var isGameOver = false;

  setGameOver() {
    isGameOver = true;
    notifyListeners();
  }

  ///reset
  reset() {
    score = 0;
    currentQuestion = 0;
    isGameOver = false;
  }
}
