import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_maker/data/app_state/single_quiz_state.dart';
import 'package:quiz_maker/ui/utilities/app_extensions.dart';
import 'package:quiz_maker/ui/widgets/control_box.dart';

class QuizWidget extends StatefulWidget {
  const QuizWidget({Key? key}) : super(key: key);

  @override
  State<QuizWidget> createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  int? selectedAnswer;
  var resultText = 'Choose answer';

  reset() {
    setState(() {
      selectedAnswer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Consumer<SingleQuizState>(builder: (_, quiz, __) {
      return Row(
        children: [
          Expanded(
              flex: 2,
              child: ControlBox(
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${quiz.currentQuestionIndex + 1} of ${quiz.quiz!.questions.length} questions',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          'Score : ${quiz.score}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    16.vSpace(),
                    Card(
                      child: SizedBox(
                        height: 128,
                        width: 256,
                        child: Center(
                          child: Text(
                            quiz.quiz!.questions[quiz.currentQuestionIndex]
                                .title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ),
                    ),
                    16.vSpace(),
                    const Divider(),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                          selectedAnswer == null
                              ? 'Choose an answer'
                              : selectedAnswer ==
                                      quiz
                                          .quiz!
                                          .questions[quiz.currentQuestionIndex]
                                          .answer
                                  ? 'Correct Answer'
                                  : 'Wrong answer',
                          style: TextStyle(
                              color: selectedAnswer == null
                                  ? null
                                  : selectedAnswer ==
                                          quiz
                                              .quiz!
                                              .questions[
                                                  quiz.currentQuestionIndex]
                                              .answer
                                      ? Colors.green
                                      : Colors.red,
                              fontWeight: FontWeight.bold)),
                    ),
                    const Divider(),
                    16.vSpace(),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: quiz
                          .quiz!.questions[quiz.currentQuestionIndex].choices
                          .map((e) => ListTile(
                                onTap: selectedAnswer != null
                                    ? null
                                    : () {
                                        setState(() {
                                          selectedAnswer = quiz
                                              .quiz!
                                              .questions[
                                                  quiz.currentQuestionIndex]
                                              .choices
                                              .indexOf(e);
                                        });
                                        quiz.increaseScore(
                                            score: selectedAnswer ==
                                                    quiz
                                                        .quiz!
                                                        .questions[quiz
                                                            .currentQuestionIndex]
                                                        .answer
                                                ? 3
                                                : 0);
                                      },
                                title: Text(e),
                                trailing: selectedAnswer != null &&
                                        quiz
                                                .quiz!
                                                .questions[
                                                    quiz.currentQuestionIndex]
                                                .answer ==
                                            quiz
                                                .quiz!
                                                .questions[
                                                    quiz.currentQuestionIndex]
                                                .choices
                                                .indexOf(e)
                                    ? const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      )
                                    : selectedAnswer != null &&
                                            selectedAnswer !=
                                                quiz
                                                    .quiz!
                                                    .questions[quiz
                                                        .currentQuestionIndex]
                                                    .answer &&
                                            selectedAnswer ==
                                                quiz
                                                    .quiz!
                                                    .questions[quiz
                                                        .currentQuestionIndex]
                                                    .choices
                                                    .indexOf(e)
                                        ? const Icon(
                                            Icons.clear,
                                            color: Colors.red,
                                          )
                                        : null,
                              ))
                          .toList(),
                    ),
                    if (selectedAnswer != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: FilledButton.icon(
                              onPressed: () {
                                quiz.goToNextQuestion();
                                reset();
                              },
                              icon: const Icon(Icons.navigate_next),
                              label: const Text('Next Question')),
                        ),
                      )
                  ],
                ),
              )),
        ],
      );
    });
  }
}
