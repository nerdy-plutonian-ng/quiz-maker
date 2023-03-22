import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_maker/data/models/quiz.dart';
import 'package:quiz_maker/ui/widgets/question.dart';
import 'package:quiz_maker/ui/widgets/title_and%20_description.dart';

import '../../data/app_state/quiz_state.dart';
import '../../data/constants/app_dimensions.dart';

class Questions extends StatelessWidget {
  const Questions({
    Key? key,
  }) : super(key: key);

  addQuestion(BuildContext context, double width,
      {Question? question, int? index}) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height - 16,
          minHeight: MediaQuery.of(context).size.height - 32,
          maxWidth: width <= AppDimensions.portraitTabletWidth
              ? double.infinity
              : AppDimensions.mobileWidth.toDouble(),
        ),
        builder: (_) {
          return Card(
              child: QuestionWidget(
            question: question,
            index: index,
          ));
        });
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Consumer<QuizState>(builder: (_, quizState, __) {
      return Column(
        children: [
          if (deviceWidth <= AppDimensions.portraitTabletWidth)
            const TitleAndDescription(),
          Card(
            child: ListTile(
              onTap: () => addQuestion(
                context,
                deviceWidth,
              ),
              title: const Text('Questions'),
              subtitle: Text(
                  '${quizState.questions?.length ?? 'No'} questions added'),
              trailing: const Icon(Icons.add_circle),
            ),
          ),
          Expanded(
              child: ListView.separated(
                  itemBuilder: (_, index) {
                    return Dismissible(
                      onDismissed: (_) {
                        quizState.removeQuestion(index);
                      },
                      key: Key(index.toString()),
                      child: ListTile(
                        onTap: () => addQuestion(context, deviceWidth,
                            question: quizState.questions?[index],
                            index: index),
                        title: Text(quizState.questions?[index].question ?? ''),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(),
                  itemCount: quizState.questions?.length ?? 0))
        ],
      );
    });
  }
}
