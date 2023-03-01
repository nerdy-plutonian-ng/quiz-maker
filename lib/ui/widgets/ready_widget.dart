import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_maker/data/app_enums/quiz_state.dart';
import 'package:quiz_maker/ui/utilities/app_extensions.dart';

import '../../data/app_state/single_quiz_state.dart';

class ReadyWidget extends StatelessWidget {
  const ReadyWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final quiz = Provider.of<SingleQuizState>(context, listen: false).quiz!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            quiz.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
              '${quiz.questions.length} question${quiz.questions.length == 1 ? '' : 's'}'),
          16.vSpace(),
          FilledButton(
              onPressed: () {
                Provider.of<SingleQuizState>(context, listen: false)
                    .setQuizState(QuizState.playing);
              },
              child: const Text('I\'m Ready')),
        ],
      ),
    );
  }
}
