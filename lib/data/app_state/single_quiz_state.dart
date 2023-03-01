import 'package:flutter/foundation.dart';
import 'package:quiz_maker/data/app_enums/quiz_state.dart';
import 'package:quiz_maker/data/models/quiz_model.dart';

class SingleQuizState with ChangeNotifier {
  ///quiz state
  var quizState = QuizState.ready;

  setQuizState(QuizState state) {
    quizState = state;
    notifyListeners();
  }

  ///quiz
  QuizModel? quiz;

  setQuiz(Map<String, dynamic> quizMap) {
    quiz = QuizModel.fromJson(quizMap);
  }

  int currentQuestionIndex = 0;

  goToNextQuestion() {
    if (quiz!.questions.length - currentQuestionIndex == 1) {
      quizState = QuizState.gameOver;
    } else {
      currentQuestionIndex++;
    }
    notifyListeners();
  }

  int score = 0;

  increaseScore({int score = 0}) {
    this.score += score;
    notifyListeners();
  }

  reset() {
    quizState = QuizState.ready;
    quiz = null;
    currentQuestionIndex = 0;
    score = 0;
  }
}
