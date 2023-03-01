import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_maker/data/app_enums/quiz_state.dart';
import 'package:quiz_maker/data/app_state/single_quiz_state.dart';
import 'package:quiz_maker/ui/widgets/game_over.dart';

import '../widgets/quiz_widget.dart';
import '../widgets/ready_widget.dart';

class PlayQuizWidget extends StatefulWidget {
  const PlayQuizWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<PlayQuizWidget> createState() => _PlayQuizWidgetState();
}

class _PlayQuizWidgetState extends State<PlayQuizWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<SingleQuizState>(
              builder: (_, quizState, __) {
                return quizState.quizState == QuizState.ready
                    ? const ReadyWidget()
                    : quizState.quizState == QuizState.playing
                        ? const QuizWidget()
                        : const GameOverWidget();
              },
            )),
      ),
    );
  }
}
