import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/app_state/solo_quiz_state.dart';

class ScoreBoard extends StatelessWidget {
  const ScoreBoard({Key? key, required this.questionsLength}) : super(key: key);

  final int questionsLength;

  @override
  Widget build(BuildContext context) {
    return Consumer<SoloQuizState>(builder: (_, state, __) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              RichText(
                text: TextSpan(
                  text: 'Question: ',
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                        text: '${state.currentQuestion + 1}/$questionsLength',
                        style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Score: ',
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                        text: state.score.toString(),
                        style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
