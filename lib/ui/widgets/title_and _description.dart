import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/app_state/quiz_state.dart';
import 'app_text_field.dart';

class TitleAndDescription extends StatelessWidget {
  const TitleAndDescription({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final quizState = Provider.of<QuizState>(context, listen: false);
    return Card(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title and description',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            AppTextField(
              textInputAction: TextInputAction.next,
              initialValue: quizState.title,
              label: 'Title',
              maxLength: 50,
              shouldValidate: true,
              textInputType: TextInputType.text,
              onChange: (text) {
                quizState.setTitle(text);
              },
            ),
            AppTextField(
              textInputAction: TextInputAction.done,
              initialValue: quizState.description,
              label: 'Description',
              maxLength: 70,
              lines: 2,
              shouldValidate: true,
              textInputType: TextInputType.text,
              onChange: (text) {
                quizState.setDescription(text);
              },
            ),
          ],
        ),
      ),
    );
  }
}
