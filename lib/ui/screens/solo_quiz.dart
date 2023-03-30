import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quiz_maker/data/app_state/solo_quiz_state.dart';
import 'package:quiz_maker/data/constants/app_dimensions.dart';
import 'package:quiz_maker/data/constants/route_paths.dart';
import 'package:quiz_maker/ui/utilities/app_extensions.dart';
import 'package:quiz_maker/ui/widgets/control_box.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/models/quiz.dart';
import '../widgets/score_board.dart';

class SoloQuiz extends StatefulWidget {
  const SoloQuiz(
      {Key? key, required this.quiz, required this.maker, required this.quizId})
      : super(key: key);

  final Quiz quiz;
  final String maker;
  final String quizId;

  @override
  State<SoloQuiz> createState() => _SoloQuizState();
}

class _SoloQuizState extends State<SoloQuiz> {
  var nextClicked = false;
  int? selectedAnswer;
  var isUpdating = false;

  Future<void> updateAllNecessaryPlaces(int score) async {
    final account = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    final userAccount = account.data()!;
    userAccount['noQuizzesPlayed'] = userAccount['noQuizzesPlayed'] + 1;
    userAccount['noSoloQuizzesPlayed'] = userAccount['noSoloQuizzesPlayed'] + 1;
    userAccount['noPointsAccumulated'] =
        userAccount['noPointsAccumulated'] + score;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(userAccount);
    final account2 = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.maker)
        .get();
    final makerAccount = account2.data()!;
    makerAccount['popularityPoints'] = makerAccount['popularityPoints'] + 1;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.maker)
        .update(makerAccount);
    final quizSnapShot = await FirebaseFirestore.instance
        .collection('quizzes')
        .doc(widget.quizId)
        .get();
    final quiz = quizSnapShot.data()!;
    quiz['popularity'] = quiz['popularity'] + 1;
    await FirebaseFirestore.instance
        .collection('quizzes')
        .doc(widget.quizId)
        .update(quiz);
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Consumer<SoloQuizState>(
      builder: (_, state, __) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: state.isGameOver
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Quiz Over',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          Text(
                            'You scored ${state.score} out of a possible ${widget.quiz.questions.length * 3} points',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          16.vSpace(),
                          FilledButton.icon(
                              onPressed: () {
                                state.reset();
                                context.goNamed(RoutePaths.root);
                              },
                              icon: const Icon(Icons.home_outlined),
                              label: const Text('Home')),
                          TextButton.icon(
                              onPressed: () {
                                Share.share('com.plutoapps.quizmaker',
                                    subject:
                                        'See how much you score on this quiz');
                              },
                              icon: Icon(Icons.share),
                              label: Text('Share'))
                        ],
                      ),
                    )
                  : Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: ControlBox(
                              child: Column(
                                children: [
                                  if (deviceWidth <=
                                      AppDimensions.portraitTabletWidth)
                                    ScoreBoard(
                                      questionsLength:
                                          widget.quiz.questions.length,
                                    ),
                                  32.vSpace(),
                                  Text(
                                    widget.quiz.questions[state.currentQuestion]
                                        .question,
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  32.vSpace(),
                                  Expanded(
                                      child: ListView.builder(
                                          itemBuilder: (_, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    border: Border.all(
                                                        color: selectedAnswer !=
                                                                    null &&
                                                                (selectedAnswer ==
                                                                        index ||
                                                                    index ==
                                                                        widget
                                                                            .quiz
                                                                            .questions[state
                                                                                .currentQuestion]
                                                                            .answer)
                                                            ? index ==
                                                                    widget
                                                                        .quiz
                                                                        .questions[state
                                                                            .currentQuestion]
                                                                        .answer
                                                                ? Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary
                                                                : Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .error
                                                            : Theme.of(context)
                                                                .colorScheme
                                                                .primaryContainer)),
                                                child: ListTile(
                                                    enabled: !nextClicked,
                                                    onTap: () {
                                                      setState(() {
                                                        selectedAnswer = index;
                                                        nextClicked = true;
                                                        if (index ==
                                                            widget
                                                                .quiz
                                                                .questions[state
                                                                    .currentQuestion]
                                                                .answer) {
                                                          state
                                                              .incrementScore();
                                                        }
                                                      });
                                                    },
                                                    title: Text(widget
                                                        .quiz
                                                        .questions[state
                                                            .currentQuestion]
                                                        .options[index]),
                                                    trailing: selectedAnswer !=
                                                                null &&
                                                            (selectedAnswer ==
                                                                    index ||
                                                                index ==
                                                                    widget
                                                                        .quiz
                                                                        .questions[
                                                                            state.currentQuestion]
                                                                        .answer)
                                                        ? Icon(
                                                            index ==
                                                                    widget
                                                                        .quiz
                                                                        .questions[state
                                                                            .currentQuestion]
                                                                        .answer
                                                                ? Icons
                                                                    .check_circle
                                                                : Icons.clear,
                                                            color: index ==
                                                                    widget
                                                                        .quiz
                                                                        .questions[state
                                                                            .currentQuestion]
                                                                        .answer
                                                                ? Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary
                                                                : Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .error,
                                                          )
                                                        : null),
                                              ),
                                            );
                                          },
                                          itemCount: widget
                                              .quiz
                                              .questions[state.currentQuestion]
                                              .options
                                              .length)),
                                  if (isUpdating)
                                    const LinearProgressIndicator(),
                                  if (nextClicked)
                                    FilledButton.tonalIcon(
                                        onPressed: isUpdating
                                            ? null
                                            : () async {
                                                if (state.currentQuestion ==
                                                    widget.quiz.questions
                                                            .length -
                                                        1) {
                                                  setState(() {
                                                    isUpdating = true;
                                                  });
                                                  await updateAllNecessaryPlaces(
                                                      state.score);
                                                  setState(() {
                                                    isUpdating = false;
                                                  });
                                                  state.setGameOver();
                                                  return;
                                                }
                                                setState(() {
                                                  nextClicked = false;
                                                  selectedAnswer = null;
                                                });
                                                state.nextQuestion();
                                              },
                                        icon: const Icon(Icons.navigate_next),
                                        label: const Text('Next'))
                                ],
                              ),
                            )),
                        if (deviceWidth > AppDimensions.portraitTabletWidth)
                          Expanded(
                              child: Row(
                            children: [
                              VerticalDivider(),
                              Expanded(
                                  child: Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          title: const Text('Question'),
                                          trailing: Text(
                                              '${state.currentQuestion + 1}/${widget.quiz.questions.length}'),
                                        ),
                                        ListTile(
                                          title: Text('Score'),
                                          trailing:
                                              Text(state.score.toString()),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ))
                            ],
                          ))
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
