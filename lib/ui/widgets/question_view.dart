import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quiz_maker/data/app_state/create_quiz_state.dart';

import '../../data/constants/route_paths.dart';

class QuestionViewWidget extends StatelessWidget {
  const QuestionViewWidget({Key? key, required this.question, this.index})
      : super(key: key);

  final Map<String, dynamic> question;
  final int? index;

  @override
  Widget build(BuildContext context) {
    final choices =
        (question['choices']! as List).map((e) => e as String).toList();
    final indices = List<int>.generate(choices.length, (index) => index);
    return ListView(
      children: [
        ListTile(
          enabled: false,
          title: const Text('Question'),
          subtitle: Text(question['title']),
          trailing: FilledButton.tonalIcon(
              onPressed: () {
                Provider.of<CreateQuizState>(context, listen: false)
                    .selectIndex(index!);
                context.pushNamed(RoutePaths.newQuestion,
                    queryParams: {'question': jsonEncode(question)});
              },
              icon: const Icon(Icons.edit_note),
              label: const Text('Edit')),
        ),
        for (var index in indices)
          CheckboxListTile(
            value: question['answer'] == index,
            onChanged: null,
            subtitle: Text(choices[index]),
            title: Text('Choice ${index + 1}'),
          )
      ],
    );
  }
}
